//
//  NSView+AMExtension.h
//  Vyana
//
//  Created by Mark Lilback on 9/27/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import <AppKit/AppKit.h>

/** Convience methods for NSView.
 */
@interface NSView (AMExtension)
/** Finds an ancestor, which can be self or a superview.
 	@param aClass The class of the ancestor to look for
 	@returns the first ancestor of aClass, or nil.
*/

-(NSView*)firstAncestorOfClass:(Class)aClass;

/** Does a deep inspection of all subviews and calls handler on any that are of aClass.
*/

-(void)enumerateSubviewsOfClass:(Class)aClass block:(void (^)(id aView, BOOL *stop))handler;

/** Returns an NSImage of the view that includes all subviews and any area offscreen
*/
-(NSImage *)imageWithSubviews;

/** Removes all subviews
 */
-(void)removeAllSubviews;

@end
