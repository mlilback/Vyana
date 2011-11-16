//
//  AMMacNavController.h
//  Vyana
//
//  Created by Mark Lilback on 11/16/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AMViewController.h"

/** 
 @class AMMacNavController
 @brief UINavigationController like class for AppKit
 
 When initialized, it creates its view and sizes it the same as the root view controller's view, placing it in the view
 heirarchy as the parent of that view.
 */


@protocol AMMacNavControllerDelegate;

@interface AMMacNavController : NSViewController
/** initializes with the specified root view controller */
-(id)initWithRootViewController:(NSViewController*)viewController;

/** optional delegate. Ideally would be weak referenced, but a number of AppKit controllers can't be weak referenced. */
@property (nonatomic, unsafe_unretained) IBOutlet id<AMMacNavControllerDelegate> delegate;

/** The root view controller at the bottom of the stack */
@property (nonatomic, strong, readonly) NSViewController *rootViewController;
/** The top view controller on the stack */
@property (nonatomic, strong, readonly) NSViewController *topViewController;
/** The array of view controllers */
@property (nonatomic, strong, readonly) NSArray *viewControllers;
/** For binding to a back button */
@property (nonatomic, assign, readonly) BOOL canPopViewController;

/** Adds viewController to the top of the stack and displays its view. */
-(void)pushViewController:(NSViewController*)viewController animated:(BOOL)animated;
/** Pops the top view controller and displays the previous view controller. Nothing happens if the top controller is the root controller.*/
-(void)popViewControllerAnimated:(BOOL)animated;
/** Pops all view controllers above the root view controller */
-(void)popToRootViewControllerAnimated:(BOOL)animated;
/** Pops to the specified view controller. Raises an exception if viewController is not on the view controller stack. */
-(void)popToViewController:(NSViewController*)viewController animated:(BOOL)animated;
@end

@protocol AMMacNavControllerDelegate <NSObject>
@optional
/** called before a view controller's view is displayed */
-(void)macNavController:(AMMacNavController*)navController willShowViewController:(NSViewController*)viewController 
			   animated:(BOOL)animated;
/** called after a view controller's view is diplayed. If animated, this is called after the animation has completed. */
-(void)macNavController:(AMMacNavController*)navController didShowViewController:(NSViewController*)viewController 
			   animated:(BOOL)animated;
@end
