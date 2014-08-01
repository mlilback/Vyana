//
//  AMControlledView.m
//
//  Created by Mark Lilback on 2/9/2010.
//  Copyright 2010-11 Agile Monks, LLC. All rights reserved.
//

#import "AMControlledView.h"
#import "MAZeroingWeakRef.h"

@interface AMControlledView()
@end

@implementation AMControlledView

-(void)viewWillMoveToSuperview:(NSView *)newSuperview
{
	[super viewWillMoveToSuperview:newSuperview];
	if ([self.viewController respondsToSelector:@selector(viewWillMoveToSuperview:)])
		[self.viewController performSelector:@selector(viewWillMoveToSuperview:) withObject:newSuperview];
}

-(void)viewDidMoveToSuperview
{
	[super viewDidMoveToSuperview];
	if ([self.viewController respondsToSelector:@selector(viewDidMoveToSuperview)])
		[self.viewController performSelector:@selector(viewDidMoveToSuperview)];
}

-(void)viewWillMoveToWindow:(NSWindow *)newWindow
{
	[super viewWillMoveToWindow:newWindow];
	if ([self.viewController respondsToSelector:@selector(viewWillMoveToWindow:)])
		[self.viewController performSelector:@selector(viewWillMoveToWindow:) withObject:newWindow];
}

-(void)viewDidMoveToWindow
{
	[super viewDidMoveToWindow];
	if ([self.viewController respondsToSelector:@selector(viewDidMoveToWindow)])
		[self.viewController performSelector:@selector(viewDidMoveToWindow)];
}

-(void)resizeSubviewsWithOldSize:(NSSize)oldBoundsSize
{
	[super resizeSubviewsWithOldSize:oldBoundsSize];
	if ([self.viewController respondsToSelector:@selector(resizeSubviewsWithOldSize:)])
		[(id)self.viewController resizeSubviewsWithOldSize:oldBoundsSize];
}

- (void)setViewController:(NSViewController *)newController
{
	if (floor(NSAppKitVersionNumber) <= NSAppKitVersionNumber10_9) {
		if (newController == (NSViewController*)self)
			newController = nil;
		id curController = _viewController;
		if (curController) {
			NSResponder *controllerNextResponder = [curController nextResponder];
			[super setNextResponder:controllerNextResponder];
			[curController setNextResponder:nil];
		}
		_viewController = newController;
		if (newController) {
			NSResponder *ownNextResponder = [self nextResponder];
			if (ownNextResponder != newController) {
				[super setNextResponder: newController];
				[newController setNextResponder:ownNextResponder];
			}
		}
	} else {
		_viewController = newController;
	}
}

- (void)setNextResponder:(NSResponder *)newNextResponder
{
	if (floor(NSAppKitVersionNumber) <= NSAppKitVersionNumber10_9) {
		id curController = self.viewController;
		if (curController) {
			[curController setNextResponder:newNextResponder];
			return;
		}
	}
	if (![newNextResponder isEqual:self])
	[super setNextResponder:newNextResponder];
}

-(void)print:(id)sender
{
	if ([self.viewController respondsToSelector:@selector(shouldHandlePrintCommand:)] &&
		![(id)self.viewController shouldHandlePrintCommand:sender])
	{
		return;
	}
	[super print:sender];
}

-(NSString*)printJobTitle
{
	if ([self.viewController respondsToSelector:@selector(printJobTitle)])
		return [self.viewController performSelector:@selector(printJobTitle)];
	return [super printJobTitle];
}


@end
