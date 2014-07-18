//
//  NSDictionary+AMExtensions.m
//
//  Created by Mark Lilback on Fri Nov 01 2002.
//  Copyright (c) 2002-2011 Agile Monks, LLC. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: 4.1
//

#import "NSDictionary+AMExtensions.h"

@implementation NSDictionary (AMExtensions)

+(id)dictionaryWithPropertyListData:(NSData*)data
{
	return [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:nil];
}

+(id)mutableDictionaryWithPropertyListData:(NSData*)data
{
	id d = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainers format:nil error:nil];
	if (![d isKindOfClass:[NSMutableDictionary class]])
		return [[d mutableCopy] autorelease];
	return d;
}

//If any item conforms to NSMutableCopying, -mutableCopy is called.
// else, if conforms to NSCopying, -copy is called.
// otherwise, same item is placed in new dict
-(NSDictionary*)deepCopy
{
	id newDict = [[[NSMutableDictionary alloc] init] autorelease];
	for (id aKey in [self allKeys]) {
		id anItem = self[aKey];
		if ([anItem conformsToProtocol:@protocol(NSMutableCopying)]) {
			anItem = [anItem mutableCopy];
			[newDict setObject:anItem forKey:aKey];
			[anItem release];
		} else if ([anItem conformsToProtocol:@protocol(NSCopying)]) {
			anItem = [anItem copy];
			[newDict setObject:anItem forKey:aKey];
			[anItem release];
		} else {
			[newDict setObject:anItem forKey:aKey];
		}
	}
	return newDict;
}

-(id)objectForKey:(NSString*)key replacingNilWith:(id)defaultValue
{
	id val = self[key];
	if (nil == val)
		val = defaultValue;
	return val;
}

-(id)objectForKeyWithNullAsNil:(NSString*)key
{
	id val = self[key];
	if ([val isKindOfClass:[NSNull class]])
		val = nil;
	return val;
}

/** Convience method for serializing to an XML property list. Asserts on an error. */
-(NSData*)xmlPropertyListData
{
	NSError *err=nil;
	NSData *d = [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListXMLFormat_v1_0 options:0 error:&err];
	ZAssert(nil == err, @"Failed to write as xml property list: %@", err);
	return d;
}
@end

@implementation NSMutableDictionary(AMExtensions)
//inits self by adding each item in items keyed by valueForKey:keyName
-(id)initWithItems:(NSArray*)items usingKeyName:(NSString*)keyName
{
	if (self = [self initWithCapacity: [items count]]) {
		for (id obj in items) {
			id key = [obj valueForKey:keyName];
			if (key)
				self[key] = obj;
		}
	}
	return self;
}
//same as setObject:forKey: but if object is nil, ignores it instead of exception
-(void)setObjectIgnoringNil:(id)object forKey:(id)key
{
	if (object)
		self[key] = object;
}
@end
