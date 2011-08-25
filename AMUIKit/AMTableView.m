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

-(void)dealloc
{
	self.doubleTapHandler=nil;
	[super dealloc];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if ([[touches anyObject] tapCount] == 2 && self.doubleTapHandler)
		self.doubleTapHandler(self);
	[super touchesEnded:touches withEvent:event];
}
@end
