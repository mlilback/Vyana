//
//  AMMacNavController.m
//  Vyana
//
//  Created by Mark Lilback on 11/16/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AMMacNavController.h"
#import <Vyana/NSColor+AMExtensions.h>

@interface AMMacNavController()
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
		NSView *view = [[NSView alloc] initWithFrame:parentView.frame];
		parentView.frame = view.bounds;
		view.wantsLayer=YES;
		view.autoresizingMask = parentView.autoresizingMask;
		view.autoresizesSubviews = parentView.autoresizesSubviews;
		[parentView.superview addSubview:view];
		[view addSubview:parentView];
		self.view = view;
	}
	return self;
}

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
	[self.myViewControllers addObject:viewController];
	self.canPopViewController=YES;
}

-(void)popViewControllerAnimated:(BOOL)animated
{
	if ([self.myViewControllers count] < 2)
		return;
	NSViewController *fromController = [self.myViewControllers lastObject];
	NSViewController *toController = [self.myViewControllers objectAtIndex:self.myViewControllers.count-2];
	[self popFromViewController:fromController toController:toController animated:animated];
	[self.myViewControllers removeLastObject];
	self.canPopViewController = self.myViewControllers.count > 1;
}

-(void)popToRootViewControllerAnimated:(BOOL)animated
{
	if (self.myViewControllers.count < 2)
		return;
	NSViewController *fromController = [self.myViewControllers lastObject];
	NSViewController *toController = self.rootViewController;
	[self popFromViewController:fromController toController:toController animated:animated];
	[self.myViewControllers removeObjectsInRange:NSMakeRange(1, self.myViewControllers.count-1)];
	self.canPopViewController = NO;
}

-(void)popToViewController:(NSViewController*)viewController animated:(BOOL)animated
{
	if (self.myViewControllers.count < 2)
		return;
	ZAssert([self.myViewControllers containsObject:viewController], @"can't pop to controller not in view controller stack");
	[self popFromViewController:self.topViewController toController:viewController animated:animated];
	while ([self.myViewControllers lastObject] != viewController)
		[self.myViewControllers removeLastObject];
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
	return [self.myViewControllers copy];
}

@synthesize rootViewController;
@synthesize myViewControllers;
@synthesize delegate;
@synthesize canPopViewController;
@end
