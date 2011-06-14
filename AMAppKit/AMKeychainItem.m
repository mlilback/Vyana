//
//  AMKeychainItem.m
//
//  Created by Mark Lilback on Tue Aug 31 2004.
//  Copyright 2004-2011 Agile Monks, LLC. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: NA
//

#import "AMKeychainItem.h"

@interface AMKeychainItem (Private)
-(NSString*)stringForAttribute:(FourCharCode)attribute;
-(int)integerForAttribute:(FourCharCode)attribute;
-(void)setAttribute:(FourCharCode)attribute toString: (NSString*)str;
-(void)setAttribute:(FourCharCode)attribute toInt: (int)intVal;
@end

@implementation AMKeychainItem
-(id)initWithItemRef:(SecKeychainItemRef)ref password:(NSString*)pass
{
	if ((self = [super init])) {
		//save ref
		itemRef = ref;
		CFRetain(itemRef);
		password = [pass retain];
	}
	return self;
}
//initializer to add a new generic item to the keychain
-(id)initWithServiceName:(NSString*)service account:(NSString*)account password:(NSString*)pass
{
	OSStatus err = noErr;
	if (([account length] < 1) || ([service length] < 1))
		[NSException raise: NSInvalidArgumentException 
			format: @"service and account are required parameters"];
	if ((self = [super init])) {
		const char *serviceStr = [service UTF8String];
		const char *accountStr = [account UTF8String];
		const char *passStr = [pass UTF8String];
		//create a ref for us
		err = SecKeychainAddGenericPassword(NULL, (UInt32)strlen(serviceStr), serviceStr,
			(UInt32)strlen(accountStr), accountStr, (UInt32)strlen(passStr), passStr, &itemRef);
		if ((noErr != err) && (errSecDuplicateItem != err))
			[NSException raise: NSGenericException format: @"AddGenericPassword returned %d", err];
	}
	return self;
}

//initializer for a new internet item to add to the keychain
-(id)initWithServer:(NSString*)server account:(NSString*)account protocol:(FourCharCode)protocol
	password:(NSString*)pass port:(UInt16)port path:(NSString*)path
{
	if (([account length] < 1) || ([server length] < 1))
		[NSException raise: NSInvalidArgumentException 
			format: @"server and account are required parameters"];
	if ((self = [super init])) {
		const char *serverStr = [server UTF8String];
		const char *accountStr = [account UTF8String];
		const char *pathStr = [path UTF8String];
		//create a ref for us
		//FIXME: need to handle error
		SecKeychainAddInternetPassword(NULL, 
			serverStr ? (UInt32)strlen(serverStr) : 0, serverStr,
			0, NULL, 
			accountStr ? (UInt32)strlen(accountStr) : 0, accountStr, 
			pathStr ? (UInt32)strlen(pathStr) : 0, pathStr,
			port, protocol, kSecAuthenticationTypeDefault, 
			(UInt32)strlen([pass UTF8String]), [pass UTF8String], &itemRef);
	}
	return self;
}

-(void)dealloc
{
	[password release];
//	if (itemRef)
//		CFRelease(itemRef);
	if (accessRef)
		CFRelease(accessRef);
	[super dealloc];
}

-(SecKeychainItemRef)keychainItemRef
{
	return itemRef;
}

-(NSString*)password
{
	if (password)
		return password;
	return nil;
}
-(void)setPassword: (NSString*)pass
{
	OSStatus err = noErr;
	
	err = SecKeychainItemModifyAttributesAndData(itemRef, nil, (UInt32)strlen([pass UTF8String]), 
		[pass UTF8String]);
	if (noErr != err)
		[NSException raise: NSGenericException format: @"SecKeychainItemModifyAttributesAndData returned %d", err];
	[password autorelease];
	password = [pass copy];
}


-(FourCharCode)protocol
{
	NSString *str = [self stringForAttribute: kSecProtocolItemAttr];
	if ([str length] == 4) {
		FourCharCode code;
		memcpy(&code, [str UTF8String], 4);
		return code;
	}
	return 0;
}
-(void)setProtocol:(FourCharCode)prot
{
	char *ptr = (char*)&prot;
	[self setAttribute: kSecProtocolItemAttr toString: [NSString stringWithFormat: @"%c%c%c%c",
		ptr[0], ptr[1], ptr[2], ptr[3]]];
}
-(FourCharCode)creator
{
	NSString *str = [self stringForAttribute: kSecCreatorItemAttr];
	if ([str length] == 4) {
		FourCharCode code;
		memcpy(&code, [str UTF8String], 4);
		return code;
	}
	return 0;
}
-(void)setCreator:(FourCharCode)creator
{
	char *ptr = (char*)&creator;
	[self setAttribute: kSecCreatorItemAttr toString: [NSString stringWithFormat: @"%c%c%c%c",
		ptr[0], ptr[1], ptr[2], ptr[3]]];
}
-(NSString*)creatorString
{
	return [self stringForAttribute: kSecCreatorItemAttr];
}
-(void)setCreatorString:(NSString *)creator
{
	[self setAttribute:kSecCreatorItemAttr toString:creator];
}

-(FourCharCode)type
{
	NSString *str = [self stringForAttribute: kSecTypeItemAttr];
	if ([str length] == 4) {
		FourCharCode code;
		memcpy(&code, [str UTF8String], 4);
		return code;
	}
	return 0;
}
-(void)setType:(FourCharCode)type
{
	char *ptr = (char*)&type;
	[self setAttribute: kSecTypeItemAttr toString: [NSString stringWithFormat: @"%c%c%c%c",
		ptr[0], ptr[1], ptr[2], ptr[3]]];
}

-(UInt16)port
{
	int pn = [self integerForAttribute: kSecPortItemAttr];
	return pn;
}
-(void)setPort:(UInt16)port
{
	int val = port;
	[self setAttribute: kSecPortItemAttr toInt: val];
}

-(NSString*)description
{
	return [self stringForAttribute: kSecDescriptionItemAttr];
}
-(void)setDescription:(NSString*)desc
{
	[self setAttribute: kSecDescriptionItemAttr toString: desc];
}

-(NSString*)server
{
	return [self stringForAttribute: kSecServerItemAttr];
}
-(void)setServer:(NSString*)server
{
	[self setAttribute: kSecServerItemAttr toString: server];
}

-(NSString*)account
{
	return [self stringForAttribute: kSecAccountItemAttr];
}
-(void)setAccount:(NSString*)account
{
	[self setAttribute: kSecAccountItemAttr toString: account];
}

-(NSString*)path
{
	return [self stringForAttribute: kSecPathItemAttr];
}
-(void)setPath:(NSString*)path
{
	[self setAttribute: kSecPathItemAttr toString: path];
}

-(NSString*)label
{
	return [self stringForAttribute:kSecLabelItemAttr ];
}
-(void)setLabel:(NSString*)label
{
	[self setAttribute: kSecLabelItemAttr toString: label];
}
@end

@implementation AMKeychainItem (Private)
-(int)integerForAttribute:(FourCharCode)attribute
{
	int val=0, *valPtr = nil;
	SecKeychainAttribute itemAttrs[] = { { attribute, 0, NULL } };
	SecKeychainAttributeList itemAttrList = { sizeof(itemAttrs) / sizeof(itemAttrs[0]), itemAttrs };
	OSStatus status = SecKeychainItemCopyContent(itemRef, NULL, &itemAttrList, NULL, NULL);
	if (noErr == status) {
		valPtr = (int*)itemAttrs[0].data;
		SecKeychainItemFreeContent(&itemAttrList, NULL);
	}
	return val;
}
-(NSString*)stringForAttribute:(FourCharCode)attribute
{
	NSString *str = nil;
	SecKeychainAttribute itemAttrs[] = { { attribute, 0, NULL } };
	SecKeychainAttributeList itemAttrList = { sizeof(itemAttrs) / sizeof(itemAttrs[0]), itemAttrs };
	OSStatus status = SecKeychainItemCopyContent(itemRef, NULL, &itemAttrList, NULL, NULL);
	if (noErr == status) {
		str = [[[NSString alloc] initWithBytes: itemAttrs[0].data 
		length: itemAttrs[0].length encoding: NSUTF8StringEncoding] autorelease];
		SecKeychainItemFreeContent(&itemAttrList, NULL);
	}
	return str;
}
-(void)setAttribute:(FourCharCode)attribute toString: (NSString*)str
{
	const char *cstr = [str UTF8String];
	SecKeychainAttribute itemAttrs[] = { { attribute, (UInt32)strlen(cstr), (char*)cstr } };
	SecKeychainAttributeList itemAttrList = { sizeof(itemAttrs) / sizeof(itemAttrs[0]), itemAttrs };
	OSStatus status = SecKeychainItemModifyContent(itemRef, &itemAttrList, 0, NULL);
	if (noErr != status)
		[NSException raise: NSGenericException format: @"SecKeychainItemModifyContent returned %d", status];
}
-(void)setAttribute:(FourCharCode)attribute toInt: (int)intVal
{
/*	SecKeychainAttribute itemAttrs[] = { { attribute, sizeof(intVal), &intVal } };
	SecKeychainAttributeList itemAttrList = { sizeof(itemAttrs) / sizeof(itemAttrs[0]), itemAttrs };
	OSStatus status = SecKeychainItemModifyContent(itemRef, &itemAttrList, 0, NULL);
	if (noErr != status)
		[NSException raise: NSGenericException format: @"SecKeychainItemModifyContent returned %d", status];
*/
	SecKeychainAttributeList list;
	SecKeychainAttribute attr;
	OSStatus err = noErr;
	
	list.count = 1;
	list.attr = &attr;
	attr.tag = attribute;
	attr.data = (void*)&intVal;
	attr.length = sizeof(intVal);
	
	err = SecKeychainItemModifyAttributesAndData(itemRef, &list, 0, NULL);
	if (noErr != err)
		[NSException raise: NSGenericException format: @"SecKeychainItemModifyAttributesAndData returned %d", err];
}
@end
