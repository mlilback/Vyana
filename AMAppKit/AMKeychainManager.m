//
//  AMKeychainManager.m
//
//  Created by Mark Lilback on Tue Aug 31 2004.
//  Copyright 2004-2011 Agile Monks, LLC. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: NA
//

#import <Security/Security.h>
#import "AMKeychainManager.h"
#import "AMKeychainItem.h"

static AMKeychainManager *sInstance=nil;

@interface AMKeychainManager()
-(SecProtocolType)schemeToProtocolType:(NSURL*)url;
@end

@implementation AMKeychainManager

+(AMKeychainManager*)defaultInstance
{
	if (nil == sInstance)
		sInstance = [[AMKeychainManager alloc] init];
	return sInstance;
}

-(id)init
{
	OSStatus err = noErr;
	if ((self = [super init])) {
		err = SecKeychainCopyDefault(&defaultKeychain);
		if (err != noErr)
			goto ERROR;
		err = SecKeychainCopySearchList(&searchList);
		if (err != noErr)
			goto ERROR;
	}
	return self;
ERROR:
	NSLog(@"keychain call called failed with code %d", err);
	[self autorelease];
	self = nil;
	return self;
}

-(void)dealloc
{
	if (searchList)
		CFRelease(searchList);
	if (defaultKeychain)
		CFRelease(defaultKeychain);
	if (sInstance == self)
		sInstance = nil;
	[super dealloc];
}

-(BOOL)disableUserInteraction
{
	Boolean en;
	if (noErr != SecKeychainGetUserInteractionAllowed(&en))
		return NO;
	interactionWasEnabled = en;
	return noErr == SecKeychainSetUserInteractionAllowed(NO);
}

-(void)reenableUserInteraction
{
	if (interactionWasEnabled)
		SecKeychainSetUserInteractionAllowed(YES);
}

//returns new item (old no longer valid), or nil if fails
-(AMKeychainItem*)addAsTrustedApplication:(NSString*)appPath toItem:(AMKeychainItem*)item
{
	OSStatus err;
	SecAccessRef access=nil;
	NSArray *trustedApps=nil;
	SecKeychainItemRef newItem=nil;
	
	SecTrustedApplicationRef macsql, tool;
	err = SecTrustedApplicationCreateFromPath(nil, &macsql);
	if (noErr != err) {
		NSLog(@"failed to create trusted application for self: %d", err);
		return nil;
	}
	err = SecTrustedApplicationCreateFromPath([appPath UTF8String], &tool);
	if (noErr != err) {
		NSLog(@"failed to create trusted application for '%@': %d", appPath, err);
		return nil;
	}
	trustedApps = [NSArray arrayWithObjects: (id)macsql, (id)tool, nil];
	err = SecAccessCreate((CFStringRef)NSLocalizedString(@"MacSQL Password",@""),
		(CFArrayRef)trustedApps, &access);
	if (noErr != err) {
		NSLog(@"SecAccessCreate failed for '%@': %d", appPath, err);
		return nil;
	}
	//we now have an access. create a new item
	err = SecKeychainItemCreateCopy([item keychainItemRef], nil, access, &newItem);
	if (noErr != err) {
		NSLog(@"failed to duplicate keychain item with new acl: %d", err);
		return nil;
	}
	id ni = [[[AMKeychainItem alloc] initWithItemRef: newItem password: nil] autorelease];
	CFRelease(newItem);
	return ni;
}

-(AMKeychainItem*)findInternetPassword:(NSURL*)url user:(NSString*)user
{
	return [self findInternetPassword:[url host] user:user path:[url path] 
		port:[[url port] integerValue] protocol:[self schemeToProtocolType:url]];
}

-(AMKeychainItem*)findInternetPassword:(NSString*)serverName user:(NSString*)user path:(NSString*)path
	port:(UInt16)port protocol:(FourCharCode)protocol 
{
	OSStatus err = noErr;
	void *passData;
	UInt32 passLen;
	SecKeychainItemRef itemRef;
	
	err = SecKeychainFindInternetPassword(searchList, (UInt32)[serverName length], [serverName UTF8String],
		0, nil, (UInt32)[user length], [user UTF8String], (UInt32)[path length], [path UTF8String], port,
		protocol, kSecAuthenticationTypeDefault, &passLen, &passData, &itemRef);
	if (errSecItemNotFound == err) {
		//due to implementation changes on Intel machines, the protocol could be endian swapped
		err = SecKeychainFindInternetPassword(searchList, (UInt32)[serverName length], [serverName UTF8String],
			0, nil, (UInt32)[user length], [user UTF8String], (UInt32)[path length], [path UTF8String], port,
			NSSwapBigIntToHost(protocol), kSecAuthenticationTypeDefault, &passLen, &passData, &itemRef);
	}
	if (noErr != err)
		return nil;
	NSString *password = [[[NSString alloc] initWithBytes: passData length: passLen 
		encoding: NSUTF8StringEncoding] autorelease];
	SecKeychainItemFreeContent(nil, passData);
	id item = [[[AMKeychainItem alloc] initWithItemRef: itemRef password: password] autorelease];
	CFRelease(itemRef);
	return item;
}

-(AMKeychainItem*)findGenericPassword:(NSString*)serviceName user:(NSString*)user
{
	OSStatus err = noErr;
	void *passData;
	UInt32 passLen;
	SecKeychainItemRef itemRef;
	
	err = SecKeychainFindGenericPassword(searchList, (UInt32)[serviceName length], [serviceName UTF8String],
		(UInt32)[user length], [user UTF8String], &passLen, &passData, &itemRef);
	if (noErr != err)
		return nil;
	NSString *password = [[[NSString alloc] initWithBytes: passData length: passLen 
		encoding: NSUTF8StringEncoding] autorelease];
	SecKeychainItemFreeContent(nil, passData);
	id item = [[[AMKeychainItem alloc] initWithItemRef: itemRef password: password] autorelease];
	CFRelease(itemRef);
	return item;
}

//create a generic password
-(AMKeychainItem*)createGenericPassword:(NSString*)serviceName user:(NSString*)user 
	password:(NSString*)password
{
	return [[AMKeychainItem alloc] initWithServiceName: serviceName 
		account: user password: password];
}

-(AMKeychainItem*)createInternetPassword:(NSURL*)url user:(NSString*)user password:(NSString*)password
{
	FourCharCode protType = [self schemeToProtocolType:url];
	return [self createInternetPassword:[url host] user:user path:[url path] 
		password:password port:[[url port] intValue] protocol:protType];
}

//create an internet password
-(AMKeychainItem*)createInternetPassword:(NSString*)serverName user:(NSString*)user path:(NSString*)path
	password:(NSString*)password port:(UInt16)port protocol:(FourCharCode)protocol
{
	AMKeychainItem *theItem = nil;
	OSStatus err = noErr;
	SecKeychainAttribute attrs[5];
	SecKeychainAttributeList attributes;
	SecKeychainItemRef itemRef=nil;
	SecAccessRef access=nil;
	int count = 0;

	if (serverName) {
		attrs[count].tag = kSecServerItemAttr;
		attrs[count].data = (void*)[serverName UTF8String];
		attrs[count].length = (UInt32)strlen(attrs[count].data);
		count++;
	}
	if (user) {
		attrs[count].tag = kSecAccountItemAttr;
		attrs[count].data = (void*)[user UTF8String];
		attrs[count].length = (UInt32)strlen(attrs[count].data);
		count++;
	}
	if (path) {
		attrs[count].tag = kSecPathItemAttr;
		attrs[count].data = (void*)[path UTF8String];
		attrs[count].length = (UInt32)strlen(attrs[count].data);
		count++;
	}
	if (port > 0) {
		attrs[count].tag = kSecPortItemAttr;
		attrs[count].data = &port;
		attrs[count].length = sizeof(port);
		count++;
	}
	if (protocol > 0) {
		attrs[count].tag = kSecProtocolItemAttr;
		attrs[count].data = &protocol;
		attrs[count].length = sizeof(protocol);
		count++;
	}
	attributes.count = count;
	attributes.attr = attrs;

	err = SecAccessCreate((CFStringRef)[[[NSBundle mainBundle] infoDictionary] objectForKey: @"CFBundleName"],
		NULL, &access);
	if (noErr != err)
		return nil;
	
	err = SecKeychainItemCreateFromContent(kSecInternetPasswordItemClass, &attributes,
		(UInt32)strlen([password UTF8String]), [password UTF8String], NULL, access, &itemRef);
	
	if (access)
		CFRelease(access);
	if (itemRef) {
		theItem = [[[AMKeychainItem alloc] initWithItemRef: itemRef password: password] autorelease];
		CFRelease(itemRef);
	}
	return theItem;
}

-(SecProtocolType)schemeToProtocolType:(NSURL*)url
{
	NSString *scheme = [url scheme];
	if ([scheme isEqualToString:@"http"]) return kSecProtocolTypeHTTP;
	if ([scheme isEqualToString:@"https"]) return kSecProtocolTypeHTTPS;
	if ([scheme isEqualToString:@"ftp"]) return kSecProtocolTypeFTP;
	if ([scheme isEqualToString:@"ldap"]) return kSecProtocolTypeLDAP;
	if ([scheme isEqualToString:@"ssh"]) return kSecProtocolTypeSSH;
	if ([scheme isEqualToString:@"svn"]) return kSecProtocolTypeSVN;
	if ([scheme isEqualToString:@"ldaps"]) return kSecProtocolTypeLDAPS;
	if ([scheme isEqualToString:@"ftps"]) return kSecProtocolTypeFTPS;
	
	return kSecProtocolTypeAny;

	/* the following types aren't supported. feel free to add them.
		kSecProtocolTypeFTPAccount  = 'ftpa',
		kSecProtocolTypeIRC         = 'irc ',
		kSecProtocolTypeNNTP        = 'nntp',
		kSecProtocolTypePOP3        = 'pop3',
		kSecProtocolTypeSMTP        = 'smtp',
		kSecProtocolTypeSOCKS       = 'sox ',
		kSecProtocolTypeIMAP        = 'imap',
		kSecProtocolTypeAppleTalk   = 'atlk',
		kSecProtocolTypeAFP         = 'afp ',
		kSecProtocolTypeTelnet      = 'teln',
		kSecProtocolTypeHTTPProxy   = 'htpx',
		kSecProtocolTypeHTTPSProxy  = 'htsx',
		kSecProtocolTypeFTPProxy    = 'ftpx',
		kSecProtocolTypeCIFS        = 'cifs',
		kSecProtocolTypeSMB         = 'smb ',
		kSecProtocolTypeRTSP        = 'rtsp',
		kSecProtocolTypeRTSPProxy   = 'rtsx',
		kSecProtocolTypeDAAP        = 'daap',
		kSecProtocolTypeEPPC        = 'eppc',
		kSecProtocolTypeIPP         = 'ipp ',
		kSecProtocolTypeNNTPS       = 'ntps',
		kSecProtocolTypeTelnetS     = 'tels',
		kSecProtocolTypeIMAPS       = 'imps',
		kSecProtocolTypeIRCS        = 'ircs',
		kSecProtocolTypePOP3S       = 'pops',
		kSecProtocolTypeCVSpserver  = 'cvsp',
	*/	
}
@end
