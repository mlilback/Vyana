//
//  NSAppleEventDescriptor+AMExtensions.m
//  Vyana
//
//  Created by Mark Lilback on 1/15/12.
//  Copyright (c) 2012 Agile Monks. All rights reserved.
//

#import "NSAppleEventDescriptor+AMExtensions.h"
#import "NSString+AMExtensions.h"

#define keyASUserRecordFields (FourCharCode)'usrf'

@implementation NSAppleEventDescriptor (AMExtensions)

#if __MAC_OS_X_VERSION_MAX_ALLOWED < 101100
+(NSAppleEventDescriptor*)descriptorWithFileURL:(NSURL*)fileUrl
{
	return [self descriptorWithDescriptorType:typeFileURL 
										 data:[fileUrl.absoluteString dataUsingEncoding:NSUTF8StringEncoding]];
}
#endif

+(NSAppleEventDescriptor*)descriptorWithNumber:(NSNumber*)number
{
	if (number == (id)kCFBooleanTrue)
		return [self descriptorWithBoolean:true];
	if (number == (id)kCFBooleanFalse)
		return [self descriptorWithBoolean:false];
	SInt16 valShort;
	UInt16 valUShort;
	UInt32 valUInt;
	SInt64 val64;
	UInt64 valU64;
	float valF;
	double valD;
	//we check all the codes documented in NSNumber as being used
	switch ([number objCType][0]) {
		case 'c':
		case 's':
			valShort = [number shortValue];
			return [self descriptorWithDescriptorType:typeSInt16 bytes:&valShort length:sizeof(valShort)];
		case 'C':
		case 'S':
			valUShort = [number unsignedShortValue];
			return [self descriptorWithDescriptorType:typeUInt16 bytes:&valUShort length:sizeof(valUShort)];
		case 'i':
		case 'l':
		default:
			return [self descriptorWithInt32:[number intValue]];
		case 'I':
		case 'L':
			valUInt = [number unsignedIntValue];
			return [self descriptorWithDescriptorType:typeUInt32 bytes:&valUInt length:sizeof(valUInt)];
		case 'q':
			val64 = [number longLongValue];
			return [self descriptorWithDescriptorType:typeSInt64 bytes:&val64 length:sizeof(val64)];
		case 'Q':
			valU64 = [number unsignedLongLongValue];
			return [self descriptorWithDescriptorType:typeUInt64 bytes:&valU64 length:sizeof(valU64)];
		case 'f':
			valF = [number floatValue];
			return [self descriptorWithDescriptorType:typeIEEE32BitFloatingPoint bytes:&valF length:sizeof(valF)];
		case 'd':
			valD = [number doubleValue];
			return [self descriptorWithDescriptorType:typeIEEE64BitFloatingPoint bytes:&valD length:sizeof(valD)];
	}
}

/**	returns a record descriptor. Only converts objects of NSString, NSNumber, and NSAppleEventDescriptor. 
 	Silently skips any other values. Keys must be strings or the value of description is used as the key. */
-(id)initWithDictionary:(NSDictionary*)dict
{
	if ((self = [self initRecordDescriptor])) {
		NSAppleEventDescriptor *userfields = [NSAppleEventDescriptor listDescriptor];
		for (id key in dict.allKeys) {
			id aKey = key;
			if (![aKey isKindOfClass:[NSString class]])
				aKey = [key description];
			id value = [dict objectForKey: aKey];
			if ([value isKindOfClass: [NSString class]])
				value = [NSAppleEventDescriptor descriptorWithString: value];
			else if ([value isKindOfClass: [NSNumber class]])
				value = [NSAppleEventDescriptor descriptorWithNumber:value];
			else if (![value isKindOfClass: [NSAppleEventDescriptor class]])
				value = nil;
			if (value) {
				//add field name. index of 0 appends
				[userfields insertDescriptor: [NSAppleEventDescriptor descriptorWithString: aKey] 
									 atIndex: 0];
				//add value
				[userfields insertDescriptor: value atIndex: 0];
			}
		}
		//if userkeys has anything in it, add to self
		if ([userfields numberOfItems])
			[self setParamDescriptor: userfields forKeyword: keyASUserRecordFields];
	}
	return self;
}

-(NSNumber*)numberValue
{
	UInt16 valUShort;
	UInt32 valUInt;
	SInt64 val64;
	UInt64 valU64;
	float valF;
	double valD;
	switch (self.descriptorType) {
		case typeTrue:
			return [NSNumber numberWithBool:YES];
		case typeFalse:
			return [NSNumber numberWithBool:NO];
		case typeBoolean:
			return [NSNumber numberWithBool:self.booleanValue];
		case typeIEEE32BitFloatingPoint:
			[self.data getBytes:&valF length:sizeof(valF)];
			return [NSNumber numberWithFloat:valF];
		case typeIEEE64BitFloatingPoint:
			[self.data getBytes:&valD length:sizeof(valD)];
			return [NSNumber numberWithDouble:valD];
		case typeSInt16:
			return [NSNumber numberWithShort:[self int32Value]];
		case typeSInt32:
		default:
			return [NSNumber numberWithInt:[self int32Value]];
		case typeSInt64:
			[self.data getBytes:&val64 length:sizeof(val64)];
			return [NSNumber numberWithLongLong:val64];
		case typeUInt16:
			[self.data getBytes:&valUShort length:sizeof(valUShort)];
			return [NSNumber numberWithUnsignedShort:valUShort];
		case typeUInt32:
			[self.data getBytes:&valUInt length:sizeof(valUInt)];
			return [NSNumber numberWithUnsignedInt:valUInt];
		case typeUInt64:
			[self.data getBytes:&valU64 length:sizeof(valU64)];
			return [NSNumber numberWithUnsignedLongLong:valU64];
	}
	return nil;
}

-(NSURL*)fileUrlValue
{
	NSAppleEventDescriptor *desc = self;
	if (self.descriptorType == typeFileURL)
		desc = [desc coerceToDescriptorType:typeFileURL];
	return [NSURL URLWithString:[NSString stringWithUTF8Data:desc.data]];
}
@end
