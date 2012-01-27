//
//  AMDebugWebView.m
//  Collabase
//
//  Created by Mark Lilback on 1/24/12.
//  Copyright (c) 2012 Agile Monks. All rights reserved.
//

#import "AMDebugWebView.h"

@interface NSObject(AMDebugWebView)
-(void)setScriptDebugDelegate:(id)d;
-(id)windowScriptObject;
-(id)functionName;
-(id)caller;
-(id)exception;
@end

@implementation AMDebugWebView

-(void)webView:(id)sender didClearWindowObject:(id)windowObject forFrame:(id)frame
{
	[sender setScriptDebugDelegate:self];
}

- (void)webView:(id)webView   exceptionWasRaised:(id)frame
       sourceId:(int)sid
           line:(int)lineno
    forWebFrame:(id)webFrame
{
    NSLog(@"NSDD: exception: sid=%d line=%d function=%@, caller=%@, exception=%@", 
          sid, lineno, [frame functionName], [frame caller], [frame exception]);
}

@end
