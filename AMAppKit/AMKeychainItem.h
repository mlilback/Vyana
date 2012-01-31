//
//  AMKeychainItem.h
//
//  Created by Mark Lilback on Tue Aug 31 2004.
//  Copyright 2004-2011 Agile Monks, LLC. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: NA
//

#import <Cocoa/Cocoa.h>
#import <Security/Security.h>

@interface AMKeychainItem : NSObject {
	@private
	SecKeychainItemRef			itemRef;
	SecAccessRef				accessRef;
	NSString*					password;
}
//initializer used by AMKeychainManager
-(id)initWithItemRef:(SecKeychainItemRef)ref password:(NSString*)pass;
//initializer for a new internet item to add to the keychain
-(id)initWithServer:(NSString*)server account:(NSString*)account protocol:(FourCharCode)protocol
	password:(NSString*)pass port:(UInt16)port path:(NSString*)path;
//initializer to add a new generic item to the keychain
-(id)initWithServiceName:(NSString*)service account:(NSString*)account password:(NSString*)pass;

-(NSString*)password;
-(void)setPassword: (NSString*)pass;

-(FourCharCode)protocol;
-(void)setProtocol:(FourCharCode)prot;

-(FourCharCode)creator;
-(void)setCreator:(FourCharCode)creator;

-(NSString*)creatorString;
-(void)setCreatorString:(NSString*)creator;

-(FourCharCode)type;
-(void)setType:(FourCharCode)type;

-(NSString*)label;
-(void)setLabel:(NSString*)label;

-(NSString*)description;
-(void)setDescription:(NSString*)desc;

-(NSString*)server;
-(void)setServer:(NSString*)server;

-(NSString*)account;
-(void)setAccount:(NSString*)account;
-(NSString*)path;
-(void)setPath:(NSString*)path;

-(UInt16)port;
-(void)setPort:(UInt16)port;

-(SecKeychainItemRef)keychainItemRef;

@end
