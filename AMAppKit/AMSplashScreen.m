//
//  AMSplashScreen.m
//  CocoaImageBuilder
//
//  Created by Mark Lilback on 6/3/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import "AMSplashScreen.h"

@interface AMSplashScreen()
@end

#pragma mark -


@implementation AMSplashScreen
-(id)initWIthContentSize:(NSSize)contentSize
{
	NSRect frame = NSZeroRect;
	frame.size = contentSize;
	NSWindow *win = [[[NSWindow alloc] initWithContentRect:frame 
												 styleMask:NSBorderlessWindowMask
												   backing:NSBackingStoreBuffered 
													 defer:YES] autorelease];
	if ((self = [super initWithWindow:win])) {
		__contentSize = contentSize;
	}
	return self;
}

-(void)dealloc
{
	[super dealloc];
}

-(NSString*)htmlDirectoryName { return @"splash"; }

@end
