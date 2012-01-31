//
//  NSTableView+AMExtensions.h
//  Vyana
//
//  Created by Mark Lilback on 10/5/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import <AppKit/AppKit.h>

/** Convience methods on NSTableView */
@interface NSTableView (AMExtensions)
/** Apple deprecated selectRow:, which was really lame. Code gets sloppy having to make an
	an index set when the vast majority of the time you just want to select a single row. */
-(void)amSelectRow:(NSInteger)row byExtendingSelection:(BOOL)extend;
@end
