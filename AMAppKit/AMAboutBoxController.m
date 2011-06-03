//
//  AMAboutBoxController.m
//  QuickCompiler
//
//  Created by Mark Lilback on 3/28/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import "AMAboutBoxController.h"

@interface AMAboutBoxController()
@property (nonatomic, assign, readwrite) WebView *webView;
-(void)loadSubviews;
@end

#pragma mark -

@implementation AMAboutBoxController
-(id)init
{
	NSRect frame = NSMakeRect(50, 646, 480, 270);
	NSWindow *win = [[[NSWindow alloc] initWithContentRect:frame 
												 styleMask:NSTitledWindowMask|NSClosableWindowMask 
												   backing:NSBackingStoreBuffered 
													 defer:YES] autorelease];
	if ((self = [super initWithWindow:win])) {
		[self loadSubviews];
		[win setDelegate:self];
	}
	return self;
}

-(void)dealloc
{
	[super dealloc];
}

-(void)windowWillClose:(NSNotification*)note
{
}

-(void)loadSubviews
{
	WebView *wv = [[WebView alloc] initWithFrame:[self.window.contentView bounds] frameName:nil groupName:nil];
	self.webView = wv;
	[self.window.contentView addSubview:wv];
	[wv release];
	[wv setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
	[wv setDrawsBackground:NO];
	[wv setFrameLoadDelegate:self];
	[wv setPolicyDelegate:self];
	NSURL *pageUrl = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html" subdirectory:@"about"];
	if (pageUrl) {
		[[wv mainFrame] loadRequest:[NSURLRequest requestWithURL:pageUrl]];
	}
	[self.window setTitle:[NSString stringWithFormat:@"About %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]]];
}

#pragma mark - web view delegate

-(void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
	//inject our dynamic data
	DOMDocument *domDoc = [[self.webView mainFrame] DOMDocument];
	NSString *newStr = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
	DOMElement *anElement = [domDoc getElementById:@"versionString"];
	[anElement replaceChild:[domDoc createTextNode:newStr] 
				   oldChild:[anElement firstChild]];
	newStr = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
	anElement = [domDoc getElementById:@"bundleVersion"];
	[anElement replaceChild:[domDoc createTextNode:newStr] 
				   oldChild:[anElement firstChild]];
	newStr = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
	anElement = [domDoc getElementById:@"appName"];
	[anElement replaceChild:[domDoc createTextNode:newStr] 
				   oldChild:[anElement firstChild]];
	[[[self.webView mainFrame] frameView] setAllowsScrolling:self.allowScrolling];
}
-(NSArray *)webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element 
   defaultMenuItems:(NSArray *)defaultMenuItems
{
	return nil; // disable contextual menu for the webView
}

-(void)webView:(WebView *)webView 
decidePolicyForNavigationAction:(NSDictionary *)actionInformation 
	   request:(NSURLRequest *)request frame:(WebFrame *)frame 
decisionListener:(id < WebPolicyDecisionListener >)listener
{
	int navType = [[actionInformation objectForKey:WebActionNavigationTypeKey] intValue];
	if (WebNavigationTypeOther == navType) {
		[listener use];
		return;
	} else if (WebNavigationTypeLinkClicked == navType) {
		//it is a url. if it for a fragment on the loaded url, use it
		if ([[request URL] fragment] &&
			[[[request URL] absoluteString] hasPrefix: [webView mainFrameURL]])
		{
			[listener use];
			return;
		} //otherwise, fire off to external browser
		[[NSWorkspace sharedWorkspace] openURL:
		 [actionInformation objectForKey:WebActionOriginalURLKey]];
	}
	[listener ignore];
}

#pragma mark - accessors & synthesizes

@synthesize webView;
@synthesize allowScrolling;

@end
