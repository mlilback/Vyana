//
//  AMTableView.m
//  Vyana
//
//  Created by Mark Lilback on 1/29/12.
//  Copyright (c) 2012 Agile Monks. All rights reserved.
//

#import "AMTableView.h"

@implementation NSTableView (AMSubclassAdditions)
-(BOOL)amHandleKeyDown:(NSEvent*)event
{
	unichar key = [[event charactersIgnoringModifiers] characterAtIndex:0];
	switch (key) {
		case NSDeleteCharacter:
			if ([self.delegate respondsToSelector:@selector(tableView:handleDeleteKey:)]) {
				[(id)self.delegate tableView:self handleDeleteKey:event];
				return YES;
			}
			break;
	}
	return NO;
}

@end

@implementation AMTableView

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
