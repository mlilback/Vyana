//
//  AMSourceListColumn.m
//
//  Copyright 2010-11 Agile Monks, LLC . All rights reserved.
//  Based on SourceListView by Mark Alldritt. <http://www.latenightsw.com/blog/>
//
//	Compatibility: Mac OS X: 10.6, iPhone: NA
//

#import "AMSourceListColumn.h"
#import "AMSourceListCell.h"
#import "AMSourceListSourceGroupCell.h"
#import "AMSourceListView.h"

@implementation AMSourceListColumn

- (void) awakeFromNib
{
	AMSourceListCell* dataCell = [[[AMSourceListCell alloc] init] autorelease];

	[dataCell setFont:[[self dataCell] font]];
	[dataCell setLineBreakMode:[[self dataCell] lineBreakMode]];

	[self setDataCell:dataCell];
}

- (id) dataCellForRow:(NSInteger) row
{
	if (row >= 0)
	{
		AMSourceListView *slv = (AMSourceListView*)[self tableView];
		if ([slv isSourceGroupItem: [slv itemAtRow:row]])
		{
			AMSourceListSourceGroupCell* groupCell = [[[AMSourceListSourceGroupCell alloc] init] autorelease];
			
			[groupCell setFont:[[self dataCell] font]];
			[groupCell setLineBreakMode:[[self dataCell] lineBreakMode]];
			return groupCell;			
		}
	}

	return [self dataCell];
}

@end
