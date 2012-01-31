//
//  AMBackgroundTask.m
//  Rc2Engine
//
//  Created by Mark Lilback on 8/16/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import "AMBackgroundTask.h"

@interface AMBackgroundTask() {
}
@property (nonatomic, retain) NSTask *theTask;
@property (nonatomic, assign) NSFileHandle *stdOut;
@property (nonatomic, assign) NSFileHandle *stdErr;
@property (nonatomic, retain) id noteRef;
@end

@implementation AMBackgroundTask

-(id)initWithCommand:(NSString*)command arguments:(NSArray*)args workingDir:(NSString*)workingDir
{
	self = [super init];
	self.theTask = [[[NSTask alloc] init] autorelease];
	[self.theTask setCurrentDirectoryPath:workingDir];
	[self.theTask setLaunchPath:command];
	[self.theTask setArguments:args ? args : [NSArray array]];
	return self;
}
/*
-(id)retain
{
	NSArray *syms = [NSThread callStackSymbols];
	NSArray *topLines = [syms subarrayWithRange:NSMakeRange(0, 8)];
	NSString *outStr = [topLines componentsJoinedByString:@"\n"];
	NSLog(@"\nretain\n%@", outStr);
	return [super retain];
}

-(oneway void)release
{
	NSArray *syms = [NSThread callStackSymbols];
	NSArray *topLines = [syms subarrayWithRange:NSMakeRange(0, 8)];
	NSString *outStr = [topLines componentsJoinedByString:@"\n"];
	[super release];
	NSLog(@"\nrelease (%ld)\n%@", [self retainCount], outStr);
}
*/
-(void)dealloc
{
	if (self.noteRef)
		[[NSNotificationCenter defaultCenter] removeObserver:self.noteRef];
	self.theTask=nil;
	self.stdOut=nil;
	self.stdErr=nil;
	self.noteRef=nil;
	[super dealloc];
}

-(BOOL)taskIsRunning
{
	return [self.theTask isRunning];
}

-(void)startTask
{
	[self startTaskWithInput:nil];
}

-(void)startTaskWithInput:(NSData*)input
{
	NSFileHandle *stdInput=nil;
	NSPipe *p = [NSPipe pipe];
	[self.theTask setStandardError:p];
	self.stdErr = [p fileHandleForReading];
	[self.stdErr readInBackgroundAndNotify];
	p = [NSPipe pipe];
	[self.theTask setStandardOutput:p];
	self.stdOut = [p fileHandleForReading];
	[self.stdOut readInBackgroundAndNotify];
	if (input) {
		p = [NSPipe pipe];
		[self.theTask setStandardInput:p];
		stdInput = [p fileHandleForWriting];
	}
	__unsafe_unretained AMBackgroundTask *blockSelf = self;
	self.noteRef = [[NSNotificationCenter defaultCenter] addObserverForName:NSFileHandleReadCompletionNotification 
													  object:nil queue:[NSOperationQueue mainQueue] 
												  usingBlock:^(NSNotification *note)
	{
		if ([note object] == blockSelf.stdOut) {
			[blockSelf.delegate backgroundTask:blockSelf 
							sentOutputData:[[note userInfo] objectForKey:NSFileHandleNotificationDataItem]];
		} else if ([note object] == blockSelf.stdErr) {
			[blockSelf.delegate backgroundTask:blockSelf 
							sentErrorData:[[note userInfo] objectForKey:NSFileHandleNotificationDataItem]];
		}
		if (blockSelf.theTask) {
			[blockSelf.stdErr readInBackgroundAndNotify];
			[blockSelf.stdOut readInBackgroundAndNotify];
		}
	}];
	[self.theTask launch];
	if (stdInput)
		[stdInput writeData:input];
}

-(void)endTask
{
	[self.theTask terminate];
}

-(void)waitUntilExit
{
	[self.theTask waitUntilExit];
}

-(int)processIdentifier
{
	return [self.theTask processIdentifier];
}

@synthesize delegate;
@synthesize theTask;
@synthesize stdOut;
@synthesize stdErr;
@synthesize noteRef;
@end

@interface AMOneShotTask() {
	NSMutableData *_data;
}
@end

@implementation AMOneShotTask
-(void)dealloc
{
	[_data release];
	[super dealloc];
}
-(void)executeTaskWithHandler:(void (^)(int termStatus, NSData *output))hbock
{
	_data = [[NSMutableData alloc] init];
	self.delegate = self;
	[self startTask];
	[self waitUntilExit];
	hbock([self.theTask terminationStatus], _data);
}
-(void)backgroundTask:(AMBackgroundTask*)task sentOutputData:(NSData*)data
{
	[_data appendData:data];
}
-(void)backgroundTask:(AMBackgroundTask*)task sentErrorData:(NSData*)data
{
	[_data appendData:data];
}

@end

