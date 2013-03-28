//
//  AMTableView.h
//  Vyana
//
//  Created by Mark Lilback on 1/29/12.
//  Copyright (c) 2012 Agile Monks. All rights reserved.
//

#import <AppKit/AppKit.h>

/** This is implemented as a category so both the AMTableView and AMOutlineView classes can
 	use it.
 */
@interface NSTableView (AMSubclassAdditions)
-(BOOL)amHandleKeyDown:(NSEvent*)event;
@end

/** A delegate supports these for additional functionality. */
@interface NSObject (AMTableViewDelegate)
/** event will be nil if a result of the delete: action from the Edit menu. */
-(void)tableView:(NSTableView*)tableView handleDeleteKey:(NSEvent*)event;
@end

@interface AMTableView : NSTableView
/** If set to YES, menuForEvent will select the cell that was clicked before returning the menu */
@property (assign) BOOL amSelectOnMenuEvent;
@end
