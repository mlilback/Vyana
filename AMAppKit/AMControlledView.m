//
//  AMControlledView.m
//
//  Created by Mark Lilback on 2/9/2010.
//  Copyright 2010-11 Agile Monks, LLC. All rights reserved.
//

#import "AMControlledView.h"


@implementation AMControlledView
- (void)setViewController:(NSViewController *)newController
{
	if (__vc) {
		NSResponder *controllerNextResponder = [__vc nextResponder];
		[super setNextResponder:controllerNextResponder];
		[__vc setNextResponder:nil];
	}
	__vc = newController;
	if (newController) {
		NSResponder *ownNextResponder = [self nextResponder];
		[super setNextResponder: __vc];
		[__vc setNextResponder:ownNextResponder];
	}
}

- (void)setNextResponder:(NSResponder *)newNextResponder
{
	if (__vc) {
		[__vc setNextResponder:newNextResponder];
		return;
	}
	[super setNextResponder:newNextResponder];
}


@synthesize viewController=__vc;
@end
