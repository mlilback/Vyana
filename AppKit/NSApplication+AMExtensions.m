//
//  NSApplication+AMExtensions.m
//
//  Created by Mark Lilback on 10/1/2010.
//  Copyright 2010-11 Agile Monks, LLC. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: NA
//

#import "AMBlockUtils.h"
#import "NSApplication+AMExtensions.h"

@interface AMSheetTrampoline : NSObject
@property (nonatomic, copy) BasicBlock1IntArg handler;
-(void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
@end

@implementation NSApplication (AMExtensions)
-(NSString*)thisApplicationsSupportFolder
{
	NSFileManager *fm = [NSFileManager defaultManager];
	NSURL *appSupportDir = [fm URLForDirectory:NSApplicationSupportDirectory 
		inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
	NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
	NSString *path = [[appSupportDir path] stringByAppendingPathComponent:appName];
	BOOL isDir=NO;
	if (![fm fileExistsAtPath:path isDirectory:&isDir])
		[fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
	return path;
}
-(NSString*)thisApplicationsCacheFolder
{
	NSFileManager *fm = [NSFileManager defaultManager];
	NSURL *appSupportDir = [fm URLForDirectory:NSCachesDirectory
		inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
	NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
	NSString *path = [[appSupportDir path] stringByAppendingPathComponent:appName];
	BOOL isDir=NO;
	if (![fm fileExistsAtPath:path isDirectory:&isDir])
		[fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
	return path;
}

-(void)beginSheet:(NSWindow*)sheet modalForWindow:(NSWindow*)parentWindow 
	completionHandler:(BasicBlock1IntArg)handler
{
	AMSheetTrampoline *tramp = [[AMSheetTrampoline alloc] init];
	tramp.handler = handler;
	[NSApp beginSheet:sheet 
	   modalForWindow:parentWindow 
		modalDelegate:tramp 
	   didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) 
		  contextInfo:nil];
	//This is to prevent clang from bitching about memory leak
	[tramp performSelector:@selector(retain)];
	[tramp release];
}
@end


@implementation AMSheetTrampoline
@synthesize handler;
-(void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
	self.handler(returnCode);
	//this is to counter the hidden retain in beginSheet:
	[self performSelector:@selector(autorelease)];
}
@end
