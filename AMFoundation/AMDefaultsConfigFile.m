//
//  AMDefaultsConfigFile.m
//
//  Created by Mark Lilback on 3/29/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import "AMDefaultsConfigFile.h"

@interface AMDefaultsConfigFile() {
	NSDictionary *__dict;
}
@end

@implementation AMDefaultsConfigFile

-(id)initWithDictionary:(NSDictionary*)dict bundle:(NSBundle*)aBundle
{
	if ((self = [super init])) {
		__dict = [dict copy];
		self.bundle = aBundle;
	}
	return self;
}

- (void)dealloc
{
	self.bundle=nil;
	[__dict release];
	[super dealloc];
}

-(NSDictionary*)configDictionary { return __dict; }

@synthesize bundle;
@end
