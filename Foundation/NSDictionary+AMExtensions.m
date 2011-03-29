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
//If any item conforms to NSMutableCopying, -mutableCopy is called.
// else, if conforms to NSCopying, -copy is called.
// otherwise, same item is placed in new dict
-(NSDictionary*)deepCopy
{
	id newDict = [[NSMutableDictionary alloc] init];
	for (id aKey in [self allKeys]) {
		id anItem = [self objectForKey:aKey];
		if ([anItem conformsToProtocol:@protocol(NSMutableCopying)]) {
			anItem = [[anItem mutableCopy] autorelease];
			[newDict setObject:anItem forKey:aKey];
			[anItem release];
		} else if ([anItem conformsToProtocol:@protocol(NSCopying)]) {
			anItem = [[anItem copy] autorelease];
			[newDict setObject:anItem forKey:aKey];
			[anItem release];
		} else {
			[newDict setObject:anItem forKey:aKey];
		}
	}
	return newDict;
}
@end

@implementation NSMutableDictionary(AMExtensions)
//inits self by adding each item in items keyed by valueForKey:keyName
-(id)initWithItems:(NSArray*)items usingKeyName:(NSString*)keyName
{
	if ((self = [self initWithCapacity: [items count]])) {
		for (id obj in items) {
			id key = [obj valueForKey:keyName];
			if (key)
				[self setObject:obj forKey:key];
		}
	}
	return self;
}
//same as setObject:forKey: but if object is nil, ignores it instead of exception
-(void)setObjectIgnoringNil:(id)object forKey:(id)key
{
	if (object)
		[self setObject:object forKey:key];
}
@end
