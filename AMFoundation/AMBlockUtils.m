//
//  AMBlockUtils.m
//  Vyana
//
//  Created by Mark Lilback on 8/19/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import "AMBlockUtils.h"

void RunAfterDelay(NSTimeInterval delay, BasicBlock block)
{
	[[[block copy] autorelease] performSelector: @selector(my_callBlock) withObject: nil afterDelay: delay];
}

@implementation NSObject (BlocksAdditions)

- (void)my_callBlock
{
	void (^block)(void) = (id)self;
	block();
}

@end
