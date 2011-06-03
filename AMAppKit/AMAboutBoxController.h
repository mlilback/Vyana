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
 The about box looks for a resource folder named "about" with an "index.html" file in it, and loads it.
 It then searches the dom for elements with the IDs specified below, inserting the appropriate content.
 
 "versionString" = CFBundleShortVersionString
 "bundleVersion" = CFBundleVersion
 "appName" = CFBundleName
 
 Any links not in the same folder (or a descendent folder) as the loaded page will be opened
 in the default web browser.
 
 The simplest use case is
 	AMAboutBoxController *aboutBox = [[AMAboutBoxController alloc] init];
 	[aboutBox.window setFrame:NSMakeRect(x, y, width, height) animate: NO];
 	[aboutBox.window makeKeyAndOrderFront:self];
 
 */

@interface AMAboutBoxController : NSWindowController<NSWindowDelegate> {
}
@property (nonatomic, assign, readonly) WebView *webView;
@property (nonatomic, assign) BOOL allowScrolling; ///defaults to NO
@end
