//
//  AMLogger.m
//  AgileMonksToolkit
//
//  Created by Mark Lilback on 8/12/2010.
//  Copyright 2010 Agile Monks, LLC. All rights reserved.
//

#import "AMLogger.h"
#include <stdio.h>
#include <fcntl.h>

NSString *AMLoggerLogFileKey = @"AMLoggerLogFile";

static AMLogger *sharedInstance=nil;

NSString *AMLoggerErrorNotification = @"AMLoggerErrorNotification";
NSString *AMLoggerWarningNotification = @"AMLoggerWarningNotification";

@interface AMLogger ()
@property (nonatomic, copy) NSString *defaultLogPath;
-(void)openLog;
-(void)startTimer;
-(void)stopTimer;
-(void)timerFired:(NSTimer *)timer;
@end

@implementation AMLogger
@synthesize logfileURL=_logUrl,	logDomains=_logDomains, echoLogToConsole=_echoToConsole;
@synthesize defaultLogPath;

-(id)init
{
	if (nil == sharedInstance) {
		self = [super init];
		NSString *bunname = [[NSBundle mainBundle] bundleIdentifier];
		if (bunname)
			bunname = [[bunname componentsSeparatedByString:@"."] lastObject];
		if (nil == bunname)
			bunname = @"amlogger";
		self.defaultLogPath = [@"/tmp/" stringByAppendingFormat:@".log", bunname];
		self.logDomains = AMLoggerDomain_Warnings;
		NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
		id obj = [def objectForKey:AMLoggerLogFileKey];
		if ([obj isKindOfClass:[NSString class]])
			self.logfileURL = [NSURL fileURLWithPath:obj];
		else if ([obj isKindOfClass:[NSData class]])
			self.logfileURL = [NSURL URLByResolvingBookmarkData:obj
				options:NSURLBookmarkResolutionWithoutMounting
				relativeToURL:nil bookmarkDataIsStale:nil error:nil];
		self.loggingEnabled = [def boolForKey:@"AMLoggerEnabled"];
		//observe our log file path so we can change it if the user/application changes it
#if (__MAC_OS_X_VERSION_MIN_REQUIRED >= 1060)
		[[NSUserDefaultsController sharedUserDefaultsController] addObserver:self 
			forKeyPath:AMLoggerLogFileKey options:0 context:nil];
#endif
	}
	return self;
}

-(void)dealloc
{
	DLog(@"how did AMLogger get dealloc'd?");
	[self closeLog];
	self.logfileURL=nil;
	[super dealloc];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object 
	change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqualToString:AMLoggerLogFileKey]) {
		NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:AMLoggerLogFileKey];
		if (nil == path)
			path = self.defaultLogPath;
		self.logfileURL = [NSURL URLWithString:path];
		[self openLog];
		return;
	}
	return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

-(NSTimeInterval)flushLogFrequency { return _flushDelay; }

-(void)setFlushLogFrequency:(NSTimeInterval)delay
{
	if ((delay == _flushDelay) || (delay < 0) || (delay >= 300))
		return;
	_flushDelay = delay;
	[self startTimer];
}

-(BOOL)loggingEnabled { return _enabled; }

-(void)setLoggingEnabled:(BOOL)flag
{
	if (flag != _enabled) {
		_enabled = flag;
		if (_enabled)
			[self openLog];
		else
			[self closeLog];
	}
}

-(NSString*)descriptionForDomain:(unsigned long)domain
{
	switch (domain) {
		default:
		case AMLoggerDomain_General: return @"general";
		case AMLoggerDomain_Errors: return @"error";
		case AMLoggerDomain_Warnings: return @"warn";
		case AMLoggerDomain_Debug: return @"debug";
		case AMLoggerDomain_Trace: return @"trace";
		case AMLoggerDomain_SQL: return @"sql";
		case AMLoggerDomain_AMInternals: return @"internals";
		case AMLoggerDomain_AppLevel1: return @"app lvl 1";
		case AMLoggerDomain_AppLevel2: return @"app lvl 1";
		case AMLoggerDomain_AppLevel3: return @"app lvl 1";
		case AMLoggerDomain_AppLevel4: return @"app lvl 1";
	}
}

#pragma mark LOGGING

-(void)logWithFormat:(NSString*)format, ...
{
	va_list args;
	va_start(args, format);
	NSString *str = [[[NSString alloc] initWithFormat:format arguments:args] autorelease];
	va_end(args);
	[self logMessage:str forDomain:AMLoggerDomain_General];
}

-(void)logErrorWithFormat:(NSString*)format, ...
{
	va_list args;
	va_start(args, format);
	NSString *str = [[[NSString alloc] initWithFormat:format arguments:args] autorelease];
	va_end(args);
	[self logMessage:str forDomain:AMLoggerDomain_Errors];
}

-(void)logWarningWithFormat:(NSString*)format, ...
{
	va_list args;
	va_start(args, format);
	NSString *str = [[[NSString alloc] initWithFormat:format arguments:args] autorelease];
	va_end(args);
	[self logMessage:str forDomain:AMLoggerDomain_Warnings];
}

-(void)logMessageForDomain:(unsigned long)domain format:(NSString*)format, ...
{
	va_list args;
	va_start(args, format);
	NSString *str = [[[NSString alloc] initWithFormat:format arguments:args] autorelease];
	va_end(args);
	[self logMessage:str forDomain:domain];
}

-(void)logMessage:(NSString*)message
{
	[self logMessage:message forDomain:AMLoggerDomain_General];
}

-(void)logErrorMessage:(NSString*)message
{
	[self logMessage:message forDomain:AMLoggerDomain_Errors];
}

-(void)logWarningMessage:(NSString*)message
{
	[self logMessage:message forDomain:AMLoggerDomain_Warnings];
}

//the primitave logging method called by all other log methods
-(void)logMessage:(NSString*)message forDomain:(unsigned long)domain
{
#ifdef AMLOGGER_ALL_TO_CONSOLE
	NSLog(@"AMLogger: %@", message);
#endif
	if (AMLoggerDomain_Warnings == domain)
		[[NSNotificationCenter defaultCenter] postNotificationName:AMLoggerWarningNotification object:message];
	if (AMLoggerDomain_Errors == domain)
		[[NSNotificationCenter defaultCenter] postNotificationName:AMLoggerErrorNotification object:message];
	//FIXME -- this code doesn't work for some reason. Alex needs to fix it.
	//	if (domain && !(domain & _logDomains))
	if (domain > _logDomains)
		return;
	if (self.echoLogToConsole)
		NSLog(@"AMLogger (%@): %@", [self descriptionForDomain:domain], message);
	if (!self.loggingEnabled)
		return;
	if (nil == _fh)
		[self openLog];
	if (_fh) {
		[_fh writeData:[[message stringByAppendingString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		if (_flushDelay < 0.5)
			[_fh synchronizeFile];
	}
}

#pragma mark PRIVATE

-(void)openLog
{
	if (_fh)
		[self closeLog];
	if (nil == self.logfileURL)
		self.logfileURL = [NSURL fileURLWithPath:self.defaultLogPath];
	int fd = open([[self.logfileURL path] UTF8String], O_CREAT|O_APPEND|O_WRONLY, S_IRUSR|S_IWUSR|S_IRWXG|S_IRWXO);
	if (fd<0) {
		NSLog(@"Failed to open %@", self.logfileURL);
		 return;
	}
	_fh = [[NSFileHandle alloc] initWithFileDescriptor: fd];
	if (_fh) {
		NSString *msg = [NSString stringWithFormat:@"Logging started: %@\n", [NSDate date]];
		[_fh writeData:[msg dataUsingEncoding:NSUTF8StringEncoding]];
		if (_flushDelay < 0.5)
			[_fh synchronizeFile];
	}
	if (self.flushLogFrequency > 0)
		[self startTimer];
}

-(void)closeLog
{
	[_fh closeFile];
	[_fh release];
	_fh = nil;
	[self stopTimer];
}

-(void)timerFired:(NSTimer*)timer
{
	if (self.loggingEnabled)
		[_fh synchronizeFile];
}

-(void)startTimer
{
	if (self.loggingEnabled) {
		[self stopTimer];
		if (_flushDelay >= 0.5) {
			_timer = [[NSTimer scheduledTimerWithTimeInterval:_flushDelay target:self
				selector:@selector(timerFired:) userInfo:nil repeats:YES] retain];
		}
	}
}

-(void)stopTimer
{
	[_timer invalidate];
	[_timer release];
	_timer = nil;
}

#pragma mark SINGLETON

+ (id)sharedInstance
{
	if (sharedInstance == nil)
		sharedInstance = [[self alloc] init];
	return sharedInstance;
}

+ (id)allocWithZone:(NSZone*)zone
{
	//Usually already set by +initialize.
	@synchronized(self) {
		if (sharedInstance) {
			//The caller expects to receive a new object, so implicitly retain it
			//to balance out the eventual release message.
			return [sharedInstance retain];
		} else {
			//When not already set, +initialize is our caller.
			//It's creating the shared instance, let this go through.
			return [super allocWithZone:zone];
		}
	}
}

- (id)copyWithZone:(NSZone*)zone
{
	return self;
}
- (id)retain
{
	return self;
}
- (NSUInteger)retainCount
{
	return UINT_MAX; // denotes an object that cannot be released
}
- (void)release
{
	// do nothing 
}
- (id)autorelease
{
	return self;
}
@end
