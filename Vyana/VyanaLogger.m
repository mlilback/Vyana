//
//  AMConstants.m
//  Vyana
//
//  Created by Mark Lilback on 9/22/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VyanaLog.h"
#import "DDASLLogger.h"
#import "DDTTYLogger.h"

@interface VyanaLogger()
@property (nonatomic, retain) NSMutableDictionary *logLevels;
@end

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
	self.logLevels = [[NSMutableDictionary alloc] init];
	self.logLevel = LOG_LEVEL_WARN;
	id obj = [[NSUserDefaults standardUserDefaults] objectForKey:@"VyanaLogLevel"];
	if (obj && [obj integerValue] >= 0)
		self.logLevel = [obj integerValue];
	return self;
}

//adds a DDASLLogger and a DDTTYLogger
-(void)startLogging
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		[DDLog removeAllLoggers];
		[DDLog addLogger:[DDASLLogger sharedInstance]];
		[DDLog addLogger:[DDTTYLogger sharedInstance]];
	});
}

-(int)logLevelForKey:(NSString*)key
{
	return [[self.logLevels objectForKey:key] intValue];
}

-(void)setLogLevel:(int)level forKey:(NSString*)key
{
	[self.logLevels setObject:[NSNumber numberWithInt:level] forKey:key];
}

@synthesize logLevel;
@synthesize logLevels;
@end
