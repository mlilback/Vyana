//
//  AMConstants.m
//  Vyana
//
//  Created by Mark Lilback on 9/22/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VyanaLog.h"

@implementation VyanaLogger

+(id)sharedInstance
{
	static dispatch_once_t pred;
	static VyanaLogger *sInstance = nil;
	
	dispatch_once(&pred, ^{ sInstance = [[self alloc] init]; });
	return sInstance;	
}

-(id)init
{
	self = [super init];
	self.logLevel = LOG_LEVEL_WARN;
	id obj = [[NSUserDefaults standardUserDefaults] objectForKey:@"VyanaLogLevel"];
	if (obj && [obj integerValue] >= 0)
		self.logLevel = [obj integerValue];
	return self;
}

@synthesize logLevel;
@end
