//
//  AMDefaultsSet.m
//  Vyana
//
//  Created by Mark Lilback on 3/29/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import "AMDefaultsSet.h"
#import "VyanaPrivate.h"

@interface AMDefaultsSet()
@property (nonatomic, retain) NSMutableDictionary *values;
@end

@implementation AMDefaultsSet

- (id)init
{
	if ((self = [super init])) {
		self.values = [NSMutableDictionary dictionary];
	}
	return self;
}

- (void)dealloc
{
	self.values=nil;
	[super dealloc];
}

-(void)takePropertiesFromDict:(NSDictionary*)dict
{
	[self.values addEntriesFromDictionary:dict];
}

-(NSArray*)allPropertyKeys
{
	return [self.values allKeys];
}

-(id)objectForKey:(NSString*)key
{
	return [self.values objectForKey:key];
}

-(NSInteger)integerForKey:(NSString*)key
{
	id val = [self.values objectForKey:key];
	if ([val isKindOfClass:[NSNumber class]])
		return [val integerValue];
	return [[val description] integerValue];
}

-(CGFloat)cgFloatForKey:(NSString*)key
{
	id val = [self.values objectForKey:key];
	if ([val isKindOfClass:[NSNumber class]])
		return [val cgFloatValue];
	return (CGFloat)[[val description] doubleValue];
}

-(BOOL)boolForKey:(NSString*)key
{
	id val = [self.values objectForKey:key];
	if ([val isKindOfClass:[NSNumber class]])
		return [val boolValue];
	return [val isEqual:@"YES"] || [val isEqual:@"true"];
}

@synthesize values;

@end
