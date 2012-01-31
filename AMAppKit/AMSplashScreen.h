//
//  AMSplashScreen.h
//  CocoaImageBuilder
//
//  Created by Mark Lilback on 6/3/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import <Vyana/AMAboutBoxController.h>

/**
 The splash screen works just like the about box, but looks for a file named "splash.html" in the about folder.
 Make sure to call showWindow: instead of makeKeyAndOrderFront: on the window itself.
 */

@interface AMSplashScreen : AMAboutBoxController {
	NSSize __contentSize;
	BOOL __didInit;
}
@property (nonatomic, assign) BOOL showNagButton;
@property (nonatomic, copy) NSURL *nagUrl;
///setting this will update the content of the DOM element with the ID of "statusMessage"
@property (nonatomic, copy) NSString *statusMessage;

-(id)initWithContentSize:(NSSize)contentSize;

//changes the content of the DOM element with ID of elemId to newText
-(void)setContent:(NSString*)newText ofElement:(NSString*)elemId;

@end
