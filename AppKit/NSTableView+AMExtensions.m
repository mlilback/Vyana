//
//  NSTableView+AMExtensions.m
//  Vyana
//
//  Created by Mark Lilback on 10/5/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import "NSTableView+AMExtensions.h"

@implementation NSTableView (AMExtensions)
-(void)amSelectRow:(NSInteger)row byExtendingSelection:(BOOL)extend
{
	NSIndexSet *set=nil;
	if (row >= 0)
		set = [NSIndexSet indexSetWithIndex:row];
	[self selectRowIndexes:set byExtendingSelection:extend];
}
@end
