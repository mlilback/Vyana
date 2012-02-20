//
//  AMAboutBoxController.m
//  QuickCompiler
//
//  Created by Mark Lilback on 3/28/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import "AMAboutBoxController.h"

@interface AMAboutBoxController() {
	void(^__compBlock)(id);
	NSDictionary *__substitutions;
}
@property (nonatomic, assign, readwrite) WebView *webView;
@property (nonatomic, assign) NSTimeInterval startTime;
-(void)loadWebview;
-(NSString*)htmlFileName; //for subclasses to override
-(void)injectValues:(NSDictionary*)dict;
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
	return [self initWithWindow:win];
}

-(id)initWithWindow:(NSWindow *)window
{
	if ((self = [super initWithWindow:window])) {
		[self loadWebview];
		[window setDelegate:self];
	}
	return self;
}

-(void)dealloc
{
	[__compBlock release];
	self.substitutions=nil;
	[super dealloc];
}

-(void)windowWillClose:(NSNotification*)note
{
}

-(NSString*)htmlFileName { return @"index"; }

-(void)fireLoadCompletionBlock
{
	__compBlock(self);
}

-(void)loadWebview
{
	WebView *wv = [[WebView alloc] initWithFrame:[self.window.contentView bounds] frameName:nil groupName:nil];
	self.webView = wv;
	[self.window.contentView addSubview:wv];
	[wv release];
	[wv setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
	[wv setDrawsBackground:NO];
	[wv setFrameLoadDelegate:self];
	[wv setPolicyDelegate:self];
	self.startTime = [NSDate timeIntervalSinceReferenceDate];
	NSURL *pageUrl = [[NSBundle mainBundle] URLForResource:[self htmlFileName] withExtension:@"html" subdirectory:@"about"];
	if (pageUrl) {
		[[wv mainFrame] loadRequest:[NSURLRequest requestWithURL:pageUrl]];
	}
	[self.window setTitle:[NSString stringWithFormat:@"About %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]]];
}

-(void)injectValues:(NSDictionary*)dict
{
	//inject our dynamic data
	DOMDocument *domDoc = [[self.webView mainFrame] DOMDocument];
	for (NSString *anId in [dict allKeys]) {
		DOMElement *anElement = [domDoc getElementById:anId];
		[anElement replaceChild:[domDoc createTextNode:[dict objectForKey:anId]] 
					   oldChild:[anElement firstChild]];
	}
}

#pragma mark - web view delegate

-(void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
	//inject our dynamic data
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	[dict setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] 
			 forKey:@"versionString"];
	[dict setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] 
			 forKey:@"bundleVersion"];
	[dict setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"] 
			 forKey:@"appName"];
	if (self.substitutions)
		[dict addEntriesFromDictionary:self.substitutions];
	[self injectValues:dict];
	//basic setup
	[[[self.webView mainFrame] frameView] setAllowsScrolling:self.allowScrolling];
	if (!self.isLoaded) {
		if (__compBlock) {
			NSTimeInterval timeDiff = [NSDate timeIntervalSinceReferenceDate] - self.startTime;
			if (self.minimumDisplayTime && timeDiff < self.minimumDisplayTime) {
				NSTimer *timer =  [NSTimer timerWithTimeInterval:self.minimumDisplayTime - timeDiff target:self 
														selector:@selector(fireLoadCompletionBlock) userInfo:nil repeats:NO];
				[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
			} else {
				[self fireLoadCompletionBlock];
			}
		}
		self.isLoaded = YES;
	}
}
-(NSArray *)webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element 
   defaultMenuItems:(NSArray *)defaultMenuItems
{
	return nil; // disable contextual menu for the webView
}

-(void)webView:(WebView *)aWebView 
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
			[[[request URL] absoluteString] hasPrefix: [aWebView mainFrameURL]])
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

-(void)setLoadCompletionBlock:(void (^)(id))block
{
	[__compBlock release];
	__compBlock = [block copy];
}

-(void)setSubstitutions:(NSDictionary *)subs
{
	[__substitutions autorelease];
	__substitutions = [subs copy];
	if (self.isLoaded) {
		//need to set the values in the already loaded page
		[self injectValues:subs];
	}
}

@synthesize webView;
@synthesize allowScrolling;
@synthesize isLoaded;
@synthesize minimumDisplayTime;
@synthesize startTime;
@synthesize substitutions=__substitutions;
@end
