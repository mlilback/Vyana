//
//  UIApplication+AMExtensions.m
//  Vyana
//
//  Created by Mark Lilback on 10/11/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import "UIApplication+AMExtensions.h"

@implementation UIApplication (AMExtensions)
-(NSString*)thisApplicationsSupportFolder
{
	NSFileManager *fm = [NSFileManager defaultManager];
	NSURL *appSupportDir = [fm URLForDirectory:NSApplicationSupportDirectory 
		inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
	return [appSupportDir path];
}
-(NSString*)thisApplicationsCacheFolder
{
	NSFileManager *fm = [NSFileManager defaultManager];
	NSURL *appSupportDir = [fm URLForDirectory:NSCachesDirectory
		inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
	return [appSupportDir path];
}

@end
