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
-(id)initWithContentSize:(NSSize)contentSize
{
	NSRect frame = NSZeroRect;
	frame.size = contentSize;
	NSWindow *win = [[[NSWindow alloc] initWithContentRect:frame 
												 styleMask:NSBorderlessWindowMask
												   backing:NSBackingStoreBuffered 
													 defer:YES] autorelease];
	if ((self = [super initWithWindow:win])) {
		__contentSize = contentSize;
		[win setHidesOnDeactivate:NO];
	}
	return self;
}

-(void)dealloc
{
	[super dealloc];
}

-(NSString*)htmlFileName { return @"splash"; }

-(IBAction)showWindow:(id)sender
{
	if (!__didInit) {
		[self.window center];
		__didInit = YES;
	}
	[super showWindow:sender];
}

//changes the content of the DOM element with ID of elemId to newText
-(void)setContent:(NSString*)newText ofElement:(NSString*)elemId
{
	DOMDocument *domDoc = [[self.webView mainFrame] DOMDocument];
	DOMElement *anElement = [domDoc getElementById:elemId];
	[anElement replaceChild:[domDoc createTextNode:newText] 
				   oldChild:[anElement firstChild]];
}

#pragma mark - accessors & synthesizers

-(NSString*)statusMessage
{
	DOMDocument *domDoc = [[self.webView mainFrame] DOMDocument];
	DOMElement *anElement = [domDoc getElementById:@"statusMessage"];
	return [anElement innerText];
}

-(void)setStatusMessage:(NSString *)statusMessage
{
	@try {
		DOMDocument *domDoc = [[self.webView mainFrame] DOMDocument];
		DOMElement *anElement = [domDoc getElementById:@"statusMessage"];
		[anElement replaceChild:[domDoc createTextNode:statusMessage] 
					   oldChild:[anElement firstChild]];
	} @catch (NSException *e) {
	}
}

@synthesize nagUrl;
@synthesize showNagButton;
@synthesize isLoaded;
@end
