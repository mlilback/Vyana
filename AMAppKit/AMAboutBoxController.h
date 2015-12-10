//
//  AMAboutBoxController.h
//  QuickCompiler
//
//  Created by Mark Lilback on 3/28/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

/**
 	\class AMAboutBoxController
 	\brief Displays an about box using WebKit

 	The about box looks for a resource folder named "about" with an "index.html" file in it, and 
 	loads it. It then searches the DOM for elements with the IDs specified below, inserting the
	appropriate content.
 
	- "versionString" = CFBundleShortVersionString
	- "bundleVersion" = CFBundleVersion
	- "appName" = CFBundleName
 
	Any links not in the same folder (or a descendent folder) as the loaded page will be opened
	in the default web browser.
 
	The simplest use case is
 	\code
 	AMAboutBoxController *aboutBox = [[AMAboutBoxController alloc] init];
 	[aboutBox.window setFrame:NSMakeRect(x, y, width, height) animate: NO];
 	[aboutBox.window makeKeyAndOrderFront:self];
 	\endcode
 */

@interface AMAboutBoxController : NSWindowController<NSWindowDelegate, WebFrameLoadDelegate, WebPolicyDelegate>
@property (nonatomic, assign, readonly) WebView *webView;
@property (nonatomic, assign) BOOL allowScrolling; ///<defaults to NO
/// do not release the controller unless this is true or your app will likely crash
@property (nonatomic, assign) BOOL isLoaded; 
///if a load completion block is set, it will not be called unless this many seconds have passed
@property (nonatomic, assign) NSTimeInterval minimumDisplayTime;
///sets dictionary of HTML element ids mapped to substitution values to replace their contents with
@property (nonatomic, copy) NSDictionary *substitutions;

-(id)init; ///<uses a default size. frame should be adjusted later
-(id)initWithWindow:(NSWindow *)window;///<designated initializer

///a block to execute once the about page is loaded
-(void)setLoadCompletionBlock:(void (^)(id))block;
@end
