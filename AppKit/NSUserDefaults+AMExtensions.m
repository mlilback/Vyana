//
//  NSUserDefaults+AMExtensions.m
//  Vyana
//
//  Created by Mark Lilback on 9/17/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import "NSUserDefaults+AMExtensions.h"

@implementation NSUserDefaults (AMExtensions)
-(id)unarchiveObjectForKey:(NSString*)key
{
	NSData *d = [self objectForKey:key];
	if (d) {
		@try {
			return [NSKeyedUnarchiver unarchiveObjectWithData:d];
		} @catch (NSException *e) {
			if ([e.name isEqualToString:NSInvalidArchiveOperationException])
				return [NSUnarchiver unarchiveObjectWithData:d];
			@throw e;
		}
	}
	return nil;
}

-(void)archiveObject:(id<NSCoding>)object forKey:(NSString*)key
{
	if (nil == object)
		[self removeObjectForKey:key];
	else
		[self setObject:[NSKeyedArchiver archivedDataWithRootObject:object] forKey:key];
}
@end
