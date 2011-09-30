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
/** Removes all subviews
 */
-(void)removeAllSubviews;
@end
