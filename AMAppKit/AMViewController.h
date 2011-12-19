//
//  AMViewController.h
//  Vyana
//
//  Created by Mark Lilback on 8/18/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

// This subclass of NSViewControllers offers the following features:
//		* keeps track of AMBlockTokens so you don't have to implement that logic
//			(see NSObject+AMBlockObservation.h)
// Be sure to check out the AMControlledViewController protocol in AMControlledView.h
// Those methods are optional for a view controller.

@interface AMViewController : NSViewController {}

-(void)saveBlockToken:(id)aToken forObject:(id)obj;
-(void)releaseAllBlockTokens;

/** If the controlled view is a subclass of AMControlledView, this method will be called
 	as appropriate.
 */
- (void)viewWillMoveToSuperview:(NSView *)newSuperview;

/** If the controlled view is a subclass of AMControlledView, this method will be called
 	as appropriate.
 */
-(void)viewDidMoveToSuperview;

/** If the controlled view is a subclass of AMControlledView, this method will be called
 as appropriate.
 */
- (void)viewWillMoveToWindow:(NSWindow *)newWindow;

/** If the controlled view is a subclass of AMControlledView, this method will be called
 as appropriate.
 */
-(void)viewDidMoveToWindow;

/** If the controlled view is a subclass of AMControlledView, this method will be called
 as appropriate.
 */
- (void)resizeSubviewsWithOldSize:(NSSize)oldBoundsSize;

@end
