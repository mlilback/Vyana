//
//  NSOutlineView+AMExtensions.m
//  Vyana
//
//  Created by Mark Lilback on 1/11/12.
//  Copyright (c) 2012 Agile Monks. All rights reserved.
//

#import "NSOutlineView+AMExtensions.h"

@implementation NSOutlineView (AMExtensions)
/** selects the item at the specified index path. Expands any ancestors of the leaf item. */
-(void)selectItemAtIndexPath:(NSIndexPath*)path
{
	NSInteger cnt = path.length;
	if (cnt < 1)
		return;
	NSUInteger *idxes = calloc(sizeof(NSUInteger), cnt);
	//use try/finally to make sure memory is freed
	@try {
		[path getIndexes:idxes];
		//expand all ancestors items
		id parItem=nil, curItem=nil;
		for (NSInteger i=0; i < cnt; i++) {
			curItem = [self.dataSource outlineView:self child:idxes[i] ofItem:parItem];
			if ([self isExpandable:curItem])
				[self expandItem:curItem];
			parItem = curItem;
		}
		//now select curItem, which is the leaf item
		NSIndexSet *iset = [NSIndexSet indexSetWithIndex:[self rowForItem:curItem]];
		[self selectRowIndexes:iset byExtendingSelection:NO];
	} @finally {
		free(idxes);
	}
}

/** returns the path to the first selected item, or nil if there is no selection. 
 	This is likely a lot more complicated than it needs to be, but I suck at visualizing this kind of math.
 	For god sakes, I spent 40 minutes writing this and had to work it out on paper and via NSLog.
 */
-(NSIndexPath*)indexPathForSelectedItem
{
	id curItem = [self itemAtRow:self.selectedRow];
	if (nil == curItem)
		return nil;
	NSMutableArray *itemStack = [NSMutableArray array];
	do {
		id parentItem = [self parentForItem:curItem];
		if (parentItem) {
			NSInteger childIdx = [self rowForItem:curItem] - [self rowForItem:parentItem] - 1;
			[itemStack addObject:[NSNumber numberWithInteger:childIdx]];
		} else {
			//no parent, so add index from root
			[itemStack addObject:[NSNumber numberWithInteger:[self rowForItem:curItem]]];
		}
		curItem = parentItem;
	} while (curItem);
	//itemStack now has the path of items up to the root in reverse order
	NSUInteger cnt = itemStack.count;
	__block NSUInteger *idxes = calloc(sizeof(NSUInteger), cnt);
	__block NSUInteger i=0;
	[itemStack enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		idxes[i++] = [obj integerValue];
	}];
	NSIndexPath *ipath = [NSIndexPath indexPathWithIndexes:idxes length:cnt];
	free(idxes);
	return ipath;
}
@end
