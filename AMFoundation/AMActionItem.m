//
//  AMActionItem.m
//  Vyana
//
//  Created by Mark Lilback on 7/7/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import "AMActionItem.h"

@implementation AMActionItem

+(AMActionItem*)actionItemWithName:(NSString*)inTitle target:(id)inTarget action:(SEL)inAction
						  userInfo:(id)userInfo;
{
	AMActionItem *ai = [[[AMActionItem alloc] init] autorelease];
	ai.title = inTitle;
	ai.target = inTarget;
	ai.action = inAction;
	ai.userInfo = userInfo;
	return ai;
}

- (void)dealloc
{
	self.title=nil;
	self.userInfo=nil;
	[super dealloc];
}

//used by views that hold action items. simply class the action on target with self as sender
-(void)performAction:(id)sender
{
	[self.target performSelector:self.action withObject:self];
}

@synthesize title;
@synthesize target;
@synthesize action;
@synthesize userInfo;
@end
