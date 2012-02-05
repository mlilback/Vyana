//
//  AMMacNavController.m
//  Vyana
//
//  Created by Mark Lilback on 11/16/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AMMacNavController.h"
#import "NSColor+AMExtensions.h"
#import "AMControlledView.h"

@interface AMMacNavController() {
	BOOL __swipeAnimationCancelled;
}
@property (nonatomic, strong, readwrite) NSViewController *rootViewController;
@property (nonatomic, strong) NSMutableArray *myViewControllers;
@property (nonatomic, assign, readwrite) BOOL canPopViewController;
-(void)popFromViewController:(NSViewController*)fromController toController:(NSViewController*)toController animated:(BOOL)animated;
@end

@implementation AMMacNavController

-(id)initWithRootViewController:(NSViewController*)viewController
{
	if ((self = [super init])) {
		self.rootViewController = viewController;
		self.myViewControllers = [NSMutableArray array];
		[self.myViewControllers addObject:viewController];
		NSView *parentView = viewController.view;
		AMControlledView *view = [[[AMControlledView alloc] initWithFrame:parentView.frame] autorelease];
		parentView.frame = view.bounds;
		view.wantsLayer=YES;
		view.autoresizingMask = parentView.autoresizingMask;
		view.autoresizesSubviews = parentView.autoresizesSubviews;
		[parentView.superview addSubview:view];
		[view addSubview:parentView];
		self.view = view;
		view.viewController = self;
		//add self to responder chain for view
	}
	return self;
}

-(BOOL)acceptsFirstResponder { return YES; }

#pragma mark - swiping

-(BOOL)wantsScrollEventsForSwipeTrackingOnAxis:(NSEventGestureAxis)axis
{
    return (axis == NSEventGestureAxisHorizontal) ? YES : NO;
}

-(void)scrollWheel:(NSEvent *)event
{
    NSDisableScreenUpdates();
/*	
	BOOL toClipView = self.currentContentView == self.videosView;
	NSView *srcView = self.currentContentView;
	NSView *dstView = toClipView ? self.clipsController.view : self.videosView;
	[dstView setHidden:NO];
	[srcView setHidden:NO];
	
	NSLog(@"starting a swipe toClip:%@", toClipView?@"YES":@"NO");
	
	if (__swipeAnimationCancelled && *__swipeAnimationCancelled == NO) {
		*__swipeAnimationCancelled=YES;
		__swipeAnimationCancelled=nil;
		NSLog(@"hiding dstView because of cancel");
		//		[dstView setHidden:YES];
	}
	
	CGFloat backItemCount = toClipView ? 0 : 1;
	CGFloat forwardItemCount = toClipView ? 1 : 0;
	
	__block BOOL animationCancelled=NO;
	[event trackSwipeEventWithOptions:0 
			 dampenAmountThresholdMin:backItemCount
								  max:forwardItemCount 
						 usingHandler:^(CGFloat gestureAmount, NSEventPhase phase, BOOL isComplete, BOOL *stop)
	 {
		 if (NSEventPhaseStationary == phase)
			 return;
		 //NSLog(@"swipe block called: amt=%1.2f, phase=%lu, complete=%d", gestureAmount, phase, isComplete);
		 if (animationCancelled) {
			 *stop=YES;
			 return;
		 }
		 if (NSEventPhaseBegan == phase) {
			 //show the dest view at the correct edge
			 NSPoint fo = dstView.frame.origin;
			 fo.x = toClipView ? NSMaxX(self.view.bounds)-20 : 0;
			 [dstView setFrameOrigin:fo];
			 [dstView setHidden:NO];
			 NSLog(@"phase begin, showing dstView at %@, src at %@", NSStringFromRect(dstView.frame), NSStringFromRect(srcView.frame));
			 return;
		 }
		 //move content by gesture amount
		 CGFloat offset = gestureAmount * self.rootView.bounds.size.width;
		 NSPoint newOrigin = dstView.frame.origin;
		 newOrigin.x = offset;
		 //NSLog(@"offseting dstView by %1.2f to %@", offset, NSStringFromPoint(newOrigin));
		 [dstView setFrameOrigin:newOrigin];
		 
		 if (NSEventPhaseEnded == phase) {
			 NSLog(@"phase end, hiding srcView");
			 //gesture successful
			 self.currentContentView = dstView;
			 //			[srcView setHidden:YES];
		 } else if (NSEventPhaseCancelled == phase) {
			 NSLog(@"phase canceled");
		 }
		 
		 if (isComplete) {
			 __swipeAnimationCancelled=nil;
		 }
	 }];
*/	NSEnableScreenUpdates();
}

#pragma mark - stack management

-(void)pushViewController:(NSViewController*)viewController animated:(BOOL)animated
{
	ZAssert(viewController, @"nil controller passed to pushViewController:animated:");
	viewController.view.frame = self.topViewController.view.frame;
	if (animated) {
		CATransition *anim = [CATransition animation];
		anim.type = kCATransitionMoveIn;
		anim.subtype = kCATransitionFromRight;
		self.view.animations = [NSDictionary dictionaryWithObject:anim forKey:@"subviews"];
		[self.view.animator replaceSubview:self.topViewController.view with:viewController.view];
	} else {
		[self.view replaceSubview:self.topViewController.view with:viewController.view];
	}
	[self willChangeValueForKey:@"topViewController"];
	[self.myViewControllers addObject:viewController];
	[self didChangeValueForKey:@"topViewController"];
	self.canPopViewController=YES;
}

-(void)popViewControllerAnimated:(BOOL)animated
{
	if ([self.myViewControllers count] < 2)
		return;
	NSViewController *fromController = [self.myViewControllers lastObject];
	NSViewController *toController = [self.myViewControllers objectAtIndex:self.myViewControllers.count-2];
	[self popFromViewController:fromController toController:toController animated:animated];
	[self willChangeValueForKey:@"topViewController"];
	[self.myViewControllers removeLastObject];
	[self didChangeValueForKey:@"topViewController"];
	self.canPopViewController = self.myViewControllers.count > 1;
}

-(void)popToRootViewControllerAnimated:(BOOL)animated
{
	if (self.myViewControllers.count < 2)
		return;
	NSViewController *fromController = [self.myViewControllers lastObject];
	NSViewController *toController = self.rootViewController;
	[self popFromViewController:fromController toController:toController animated:animated];
	[self willChangeValueForKey:@"topViewController"];
	[self.myViewControllers removeObjectsInRange:NSMakeRange(1, self.myViewControllers.count-1)];
	[self didChangeValueForKey:@"topViewController"];
	self.canPopViewController = NO;
}

-(void)popToViewController:(NSViewController*)viewController animated:(BOOL)animated
{
	if (self.myViewControllers.count < 2)
		return;
	ZAssert([self.myViewControllers containsObject:viewController], @"can't pop to controller not in view controller stack");
	[self popFromViewController:self.topViewController toController:viewController animated:animated];
	[self willChangeValueForKey:@"topViewController"];
	while ([self.myViewControllers lastObject] != viewController)
		[self.myViewControllers removeLastObject];
	[self didChangeValueForKey:@"topViewController"];
	self.canPopViewController = self.myViewControllers.count > 1;
}

-(void)popFromViewController:(NSViewController*)fromController toController:(NSViewController*)toController animated:(BOOL)animated
{
	toController.view.frame = self.view.bounds;
	if (animated) {
		CATransition *anim = [CATransition animation];
		anim.type = kCATransitionMoveIn;
		anim.subtype = kCATransitionFromLeft;
		self.view.animations = [NSDictionary dictionaryWithObject:anim forKey:@"subviews"];
		[self.view.animator replaceSubview:fromController.view with:toController.view];
	} else {
		[self.view replaceSubview:fromController.view with:toController.view];
	}
}

#pragma mark - accessors/synthesizers

-(NSViewController*)topViewController
{
	return [self.myViewControllers lastObject];
}

-(NSArray*)viewControllers
{
	return [[self.myViewControllers copy] autorelease];
}

@synthesize rootViewController;
@synthesize myViewControllers;
@synthesize delegate;
@synthesize canPopViewController;
@end
