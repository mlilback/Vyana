//
//  AMBCrypt.h
//  Vyana
//
//  Created by Mark Lilback on 8/30/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//
// this is straight copy of https://github.com/dsibilly/bcrypt_objc
// which is public domain, so I can do that.
// use should be obvious, and I hate c style comments

#import <Foundation/Foundation.h>

// The work factor of bcrypt determines how expensive you wish this hash
// function to be. The higher it is, the longer it takes to compute (and thus
// the longer it takes to break).
#define kAMBCryptDefaultWorkFactor 12


@interface AMBCrypt : NSObject

+ (NSString*)hash:(NSString*)password;
+ (NSString*)hash:(NSString*)password workFactor:(NSUInteger)workFactor;

+ (BOOL)check:(NSString*)password againstHash:(NSString*)storedHash;

@end
