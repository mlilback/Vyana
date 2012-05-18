//
//  NSData+AMExtensions.m
//  Vyana
//
//  Created by Mark Lilback on 5/17/12.
//  Copyright (c) 2012 Agile Monks. All rights reserved.
//

#import "NSData+AMExtensions.h"

@implementation NSData (AMExtensions)
//based on <http://stackoverflow.com/questions/1305225/best-way-to-serialize-a-nsdata-into-an-hexadeximal-string>
-(NSString*)hexidecimalString
{
	const unsigned char *dataBuffer = (const unsigned char *)[self bytes];
	if (!dataBuffer)
		return [NSString string];
	
	NSUInteger          dataLength  = [self length];
	NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
	
	for (int i = 0; i < dataLength; ++i)
		[hexString appendFormat:@"%02x", (unsigned long)dataBuffer[i]];
	
	return [NSString stringWithString:hexString];
}
@end
