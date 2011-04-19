//
//  AMStateTransition.m
//  Vyana
//
//  Created by Mark Lilback on 4/18/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import "AMStateTransition.h"

@implementation AMStateTransition

- (id)init
{
	if ((self = [super init])) {
	}
	return self;
}

- (void)dealloc
{
	self.startState=nil;
	self.endState=nil;
	[super dealloc];
}

@synthesize startState;
@synthesize endState;
@synthesize event=__event;
@end
