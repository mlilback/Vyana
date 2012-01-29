//
//  AMOutlineView.m
//  Vyana
//
//  Created by Mark Lilback on 1/29/12.
//  Copyright (c) 2012 Agile Monks. All rights reserved.
//

#import "AMOutlineView.h"
#import "AMTableView.h"

@implementation AMOutlineView

-(BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
	SEL action = [menuItem action];
	if (action == @selector(delete:)) {
		return [self selectedRow] != -1;
	}
	return YES;
}

-(IBAction)delete:(id)sender
{
	if ([self.delegate respondsToSelector:@selector(tableView:handleDeleteKey:)])
		[(id)self.delegate tableView:self handleDeleteKey:nil];
}

-(void)keyDown:(NSEvent *)theEvent
{
	if (![self amHandleKeyDown:theEvent])
		[super keyDown:theEvent];
}

@end
