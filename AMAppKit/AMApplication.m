//
//  AMApplication.m
//
//  Created by Mark Lilback on 3/27/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: NA
//

#import "AMApplication.h"

@interface AMApplication() {
	BOOL _isTerm;
}
@end

@implementation AMApplication

-(BOOL)isTerminating { return _isTerm; }

-(void)terminate:(id)sender
{
	_isTerm=YES;
	[super terminate:sender];
}

-(void)finishLaunching
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSURL *url = [[NSBundle mainBundle] URLForResource:@"DefaultDefaults" withExtension:@"plist"];
	NSDictionary *d = [NSDictionary dictionaryWithContentsOfURL:url];
	if (d)
		[defaults registerDefaults:d];
	[super finishLaunching];
}

-(void)loadFScriptIfAvailable
{
	if ([[NSBundle bundleWithPath:@"~/Library/Frameworks/FScript.framework"] load] ||
		 [[NSBundle bundleWithPath:@"/Library/Frameworks/FScript.framework"] load])
	{
		//we loaded it. install the menu
		id mitem = [[NSClassFromString(@"FScriptMenuItem") alloc] init];
		if (mitem)
			[[NSApp mainMenu] addItem:mitem];
	}	
}

-(NSURL*)appSupportDirectoryURL
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSURL *libraryURL = [[fileManager URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
	return [libraryURL URLByAppendingPathComponent:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]];
}
@end
