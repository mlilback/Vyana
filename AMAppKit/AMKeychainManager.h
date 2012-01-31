//
//  AMKeychainManager.h
//
//  Created by Mark Lilback on Tue Aug 31 2004.
//  Copyright 2004-2011 Agile Monks, LLC. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: NA
//

#import <Cocoa/Cocoa.h>

@class AMKeychainItem;

@interface AMKeychainManager : NSObject {
	@private
	SecKeychainRef			defaultKeychain;
	CFArrayRef				searchList;
	BOOL					interactionWasEnabled;
	
}
+(AMKeychainManager*)defaultInstance;

//non-GUI apps need to disable interaction
-(BOOL)disableUserInteraction;
-(void)reenableUserInteraction;

//looks up an internet password and returns object encapsulating it
-(AMKeychainItem*)findInternetPassword:(NSString*)serverName user:(NSString*)user path:(NSString*)path
	port:(UInt16)port protocol:(FourCharCode)protocol;

-(AMKeychainItem*)findInternetPassword:(NSURL*)url user:(NSString*)user;

//looks up a generic password and returns object encapsulating it
-(AMKeychainItem*)findGenericPassword:(NSString*)serviceName user:(NSString*)user;

//create an internet password
-(AMKeychainItem*)createInternetPassword:(NSString*)serverName user:(NSString*)user path:(NSString*)path
	password:(NSString*)password port:(UInt16)port protocol:(FourCharCode)protocol;

//create an internet password using an NSURL. Thr url scheme needs to match one of the SecProtocolType
// constants in SecKeychain.h. Not all are fully implemented, but the major ones are.
-(AMKeychainItem*)createInternetPassword:(NSURL*)url user:(NSString*)user password:(NSString*)password;

//create a generic password
-(AMKeychainItem*)createGenericPassword:(NSString*)serviceName user:(NSString*)user 
	password:(NSString*)password;

//returns new item (old no longer valid), or nil if fails
-(AMKeychainItem*)addAsTrustedApplication:(NSString*)appPath toItem:(AMKeychainItem*)item;
@end
