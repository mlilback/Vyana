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

@interface AMSplashScreen : AMAboutBoxController {
	NSSize __contentSize;
}

-(id)initWIthContentSize:(NSSize)contentSize;

@end
