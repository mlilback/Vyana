//
//  NSFileManager+AMExtensions.m
//  Vyana
//
//  Created by Mark Lilback on 8/19/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import "NSFileManager+AMExtensions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSFileManager (AMExtensions)

-(NSString*)md5ForFileAtPath:(NSString*)path
{
	unsigned char outputData[CC_MD5_DIGEST_LENGTH];
	
	NSData *inputData = [[NSData alloc] initWithContentsOfFile:path];
	CC_MD5([inputData bytes], (CC_LONG)[inputData length], outputData);
	[inputData release];
	
	NSMutableString *hash = [NSMutableString string];
	
	for (NSUInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
		[hash appendFormat:@"%02x", outputData[i]];
	}
	
	//return an immutable string
	return [[hash copy] autorelease];
}
@end
