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

@interface VyanaLogFormatter: NSObject<DDLogFormatter>
@end

@interface VyanaASLLogFormatter : NSObject<DDLogFormatter>
@end

@interface VyanaLogger()
@property (nonatomic, retain) NSMutableDictionary *logLevels;
@property (nonatomic, retain) NSMutableDictionary *logKeys;
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
	self.logLevels = [NSMutableDictionary dictionary];
	self.logKeys = [NSMutableDictionary dictionary];
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
		DDASLLogger *asl = [DDASLLogger sharedInstance];
		[asl setLogFormatter:[[[VyanaASLLogFormatter alloc] init] autorelease]];
		[DDLog addLogger:asl];
		DDTTYLogger *ttyLogger = [DDTTYLogger sharedInstance];
		[ttyLogger setLogFormatter:[[[VyanaLogFormatter alloc] init] autorelease]];
		[DDLog addLogger:ttyLogger];
	});
}

-(NSString*)logKeyForContext:(int)ctx
{
	return [self.logKeys objectForKey:[NSNumber numberWithInt:ctx]];
}

-(void)setLogKey:(NSString*)key forContext:(int)ctx
{
	[self.logKeys setObject:[NSNumber numberWithInt:ctx] forKey:key];
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
@synthesize logKeys;
@end

@implementation VyanaLogFormatter
-(NSString*)formatLogMessage:(DDLogMessage*)logMessage
{
	NSString *level = @"-----";
	switch (logMessage->logFlag) {
		case LOG_FLAG_ERROR: level = @"ERROR"; break;
		case LOG_FLAG_WARN: level = @"WARN "; break;
		case LOG_FLAG_INFO: level = @"INFO "; break;
	}
	NSString *context=nil;
	if (VYANA_LOG_CONTEXT == logMessage->logContext) {
		context = @"Vyana";
	} else {
		context = [[VyanaLogger sharedInstance] logKeyForContext:logMessage->logContext];
		if (nil == context) {
			char ctx[5];
			bcopy(&logMessage->logContext, &ctx[0], sizeof(int));
			ctx[4] = 0;
			context = [NSString stringWithUTF8String:ctx];
		}
	}
	return [NSString stringWithFormat:@"%@ | %@ | %@", level, context, logMessage->logMsg];
}
@end

@implementation VyanaASLLogFormatter
-(NSString*)formatLogMessage:(DDLogMessage *)logMessage
{
	if (logMessage->logLevel <= LOG_LEVEL_WARN)
		return logMessage->logMsg;
	return nil;
}
@end
