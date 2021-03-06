//
//  AMBCrypt.m
//  Vyana
//
//  Created by Mark Lilback on 8/30/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import "AMBCrypt.h"
#import "bcrypt.h"

#define kAMBCryptDefaultWorkFactor 10

@implementation AMBCrypt

+ (NSString*)hash:(NSString*)password
{
	return [AMBCrypt hash:password workFactor:kAMBCryptDefaultWorkFactor];
}



+ (NSString*)hash:(NSString*)password workFactor:(NSUInteger)workFactor
{
	if (workFactor < 4 || workFactor > 31)
		workFactor = kAMBCryptDefaultWorkFactor;
	
	char salt[BCRYPT_HASHSIZE];
	char hash[BCRYPT_HASHSIZE];
	
	NSAssert(bcrypt_gensalt((int)workFactor, salt) == 0, @"Error generating Blowfish salt");
	NSAssert(bcrypt_hashpw([password cStringUsingEncoding:[NSString defaultCStringEncoding]], salt, hash) == 0, @"Error generating BCrypt hash");
	return [NSString stringWithCString:hash 
	                          encoding:[NSString defaultCStringEncoding]];
}

+ (BOOL)compareSecret:(NSString*)secret againstHash:(NSString*)hash
{
	NSString *salt = [hash substringWithRange:NSMakeRange(7, 29)];
	char chash[BCRYPT_HASHSIZE];
	bcrypt_hashpw([secret UTF8String], [salt UTF8String], chash);
	NSString *testhash = [NSString stringWithCString:chash encoding:NSUTF8StringEncoding];
	return [hash isEqualToString:testhash];
}


+ (BOOL)check:(NSString*)password
  againstHash:(NSString*)storedHash
{
	return [[self hash:password workFactor:kAMBCryptDefaultWorkFactor] isEqualToString:storedHash];
}


@end
