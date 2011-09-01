//
//  AMTableView.m
//  Vyana
//
//  Created by Mark Lilback on 8/25/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import "AMTableView.h"

@implementation AMTableView
@synthesize doubleTapHandler;
@synthesize deselectOnTouchesOutsideCells;

-(void)dealloc
{
	self.doubleTapHandler=nil;
	[super dealloc];
}

-(void)handleDeselect
{
	NSIndexPath *path = [self indexPathForSelectedRow];
	if (path)
		[self deselectRowAtIndexPath:path animated:YES];
	if ([self.delegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)])
		[self.delegate tableView:self didDeselectRowAtIndexPath:path];
	[[NSNotificationCenter defaultCenter] postNotificationName:UITableViewSelectionDidChangeNotification object:self];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	BOOL shouldDeselect=NO;
	if (self.deselectOnTouchesOutsideCells) {
		for (UITouch *aTouch in touches) {
			if (nil == [self indexPathForRowAtPoint: [aTouch locationInView:self]]) {
				shouldDeselect=YES;
				break;
			}
		}
		if (shouldDeselect)
			[self handleDeselect];
	}
	[super touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if ([[touches anyObject] tapCount] == 2 && self.doubleTapHandler)
		self.doubleTapHandler(self);
	[super touchesEnded:touches withEvent:event];
}
@end
