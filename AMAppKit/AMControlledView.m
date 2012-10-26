//
//  AMControlledView.m
//
//  Created by Mark Lilback on 2/9/2010.
//  Copyright 2010-11 Agile Monks, LLC. All rights reserved.
//

#import "AMControlledView.h"
#import "MAZeroingWeakRef.h"

@interface AMControlledView()
@property (nonatomic, strong) MAZeroingWeakRef *vcWeakRef;
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

-(NSViewController*)viewController
{
	return self.vcWeakRef.target;
}

- (void)setViewController:(NSViewController *)newController
{
	id curController = self.vcWeakRef.target;
	if (curController) {
		NSResponder *controllerNextResponder = [curController nextResponder];
		[super setNextResponder:controllerNextResponder];
		[curController setNextResponder:nil];
	}
	self.vcWeakRef = [[MAZeroingWeakRef alloc] initWithTarget:newController];
	if (newController) {
		NSResponder *ownNextResponder = [self nextResponder];
		[super setNextResponder: newController];
		[newController setNextResponder:ownNextResponder];
	}
}

- (void)setNextResponder:(NSResponder *)newNextResponder
{
	id curController = self.vcWeakRef.target;
	if (curController) {
		[curController setNextResponder:newNextResponder];
		return;
	}
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
