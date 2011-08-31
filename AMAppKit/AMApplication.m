//
//  AMApplication.m
//
//  Created by Mark Lilback on 3/27/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: NA
//

#import "AMApplication.h"

@implementation AMApplication

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
@end
