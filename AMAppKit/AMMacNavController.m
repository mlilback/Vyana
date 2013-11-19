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

@interface AMMacNavTopView : AMControlledView {
}
@property BOOL constraintsSetup;
@end

@interface AMMacNavController() {
	BOOL __swipeAnimationCancelled;
}
@property (nonatomic, strong, readwrite) NSViewController *rootViewController;
@property (nonatomic, strong) NSMutableArray *myViewControllers;
@property (nonatomic, assign, readwrite) BOOL canPopViewController;
@property (nonatomic, copy) NSArray *childConstraints;
@property (nonatomic, strong) NSView *viewBeingReplaced;
@end

@implementation AMMacNavController

-(id)initWithRootViewController:(NSViewController*)viewController
{
	if ((self = [super init])) {
		self.rootViewController = viewController;
		self.myViewControllers = [NSMutableArray array];
		[self.myViewControllers addObject:viewController];
		NSView *parentView = viewController.view;
		AMMacNavTopView *view = [[[AMMacNavTopView alloc] initWithFrame:parentView.frame] autorelease];
		parentView.frame = view.bounds;
		view.wantsLayer=YES;
		view.autoresizingMask = parentView.autoresizingMask;
		view.autoresizesSubviews = parentView.autoresizesSubviews;
		view.translatesAutoresizingMaskIntoConstraints = YES;
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

-(void)notifyDidChangeView
{
	if ([self.delegate respondsToSelector:@selector(macNavController:didShowViewController:animated:)])
		[self.delegate macNavController:self didShowViewController:self.topViewController animated:YES];
}

#pragma mark - stack management

-(void)pushViewController:(NSViewController*)viewController animated:(BOOL)animated
{
	ZAssert(viewController, @"nil controller passed to pushViewController:animated:");
	viewController.view.frame = self.topViewController.view.frame;
	if (animated) {
		self.viewBeingReplaced = self.topViewController.view;
		CGFloat width = self.topViewController.view.bounds.size.width;
		NSArray *constraints = [self layoutConstraintsForView:viewController.view offsetBy:NSMakePoint(width, 0)];
		viewController.view.translatesAutoresizingMaskIntoConstraints = NO;
		[self.view addSubview:viewController.view];
		[self.view addConstraints:constraints];
		[[[self.view.constraints objectAtIndex:0] animator] setConstant:-width];
		[[[constraints objectAtIndex:0] animator] setConstant:0.0];
	} else {
		[self.view replaceSubview:self.topViewController.view with:viewController.view];
	}
	[self willChangeValueForKey:@"topViewController"];
	if (viewController) //we assert it is not nil, but clang gives a warning so we have this useless if statement
		[self.myViewControllers addObject:viewController];
	[self didChangeValueForKey:@"topViewController"];
	self.canPopViewController=YES;
	[self notifyDidChangeView];
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
	[self notifyDidChangeView];
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
	[self notifyDidChangeView];
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
	[self notifyDidChangeView];
}

-(void)popFromViewController:(NSViewController*)fromController toController:(NSViewController*)toController animated:(BOOL)animated
{
	toController.view.frame = self.view.bounds;
	if (animated) {
		self.viewBeingReplaced = self.topViewController.view;
		CGFloat width = fromController.view.bounds.size.width;
		NSArray *constraints = [self layoutConstraintsForView:toController.view offsetBy:NSMakePoint(-width, 0)];
		toController.view.translatesAutoresizingMaskIntoConstraints = NO;
		[self.view addSubview:toController.view];
		[self.view addConstraints:constraints];
		[[[self.view.constraints objectAtIndex:0] animator] setConstant:width];
		[[[constraints objectAtIndex:0] animator] setConstant:0.0];
	} else {
		[self.view replaceSubview:fromController.view with:toController.view];
	}
	[self notifyDidChangeView];
}

#pragma mark - layout

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
	if (flag)
		[self.viewBeingReplaced removeFromSuperview];
	self.viewBeingReplaced=nil;
}

-(NSArray*)layoutConstraintsForView:(NSView*)view offsetBy:(NSPoint)offset
{
	NSMutableArray *constraints = [NSMutableArray arrayWithCapacity:4];
	[constraints addObject:[NSLayoutConstraint constraintWithItem:view
														attribute:NSLayoutAttributeLeft
														relatedBy:NSLayoutRelationEqual
														   toItem:self.view
														attribute:NSLayoutAttributeLeft
													   multiplier:1.0
														 constant:offset.x]];
	[constraints addObject:[NSLayoutConstraint constraintWithItem:view
														attribute:NSLayoutAttributeWidth
														relatedBy:NSLayoutRelationEqual
														   toItem:self.view
														attribute:NSLayoutAttributeWidth
													   multiplier:1.0
														 constant:0]];
	[constraints addObject:[NSLayoutConstraint constraintWithItem:view
														attribute:NSLayoutAttributeTop
														relatedBy:NSLayoutRelationEqual
														   toItem:self.view
														attribute:NSLayoutAttributeTop
													   multiplier:1.0
														 constant:offset.y]];
	[constraints addObject:[NSLayoutConstraint constraintWithItem:view
														attribute:NSLayoutAttributeHeight
														relatedBy:NSLayoutRelationEqual
														   toItem:self.view
														attribute:NSLayoutAttributeHeight
													   multiplier:1.0
														 constant:0]];
	CABasicAnimation *animation = [CABasicAnimation animation];
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	animation.delegate = self;
	[[constraints objectAtIndex:0] setAnimations:@{@"constant" : animation}];
	return constraints;
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

@implementation AMMacNavTopView
@end