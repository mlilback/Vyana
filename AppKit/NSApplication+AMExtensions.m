//
//  NSApplication+AMExtensions.m
//
//  Created by Mark Lilback on 10/1/2010.
//  Copyright 2010-11 Agile Monks, LLC. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: NA
//

#import "NSApplication+AMExtensions.h"


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
@end
