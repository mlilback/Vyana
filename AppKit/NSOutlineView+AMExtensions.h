//
//  NSOutlineView+AMExtensions.h
//  Vyana
//
//  Created by Mark Lilback on 1/11/12.
//  Copyright (c) 2012 Agile Monks. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface NSOutlineView (AMExtensions)
/** returns the path to the first selected item, or nil if there is no selection. */
-(NSIndexPath*)indexPathForSelectedItem;
/** selects the item at the specified index path. Expands any ancestors of the leaf item. */
-(void)selectItemAtIndexPath:(NSIndexPath*)path;
@end
