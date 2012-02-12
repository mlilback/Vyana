//
//  NSTimer+AMExtensions.m
//  Vyana
//
//  Created by Mark Lilback on 2/12/12.
//  Copyright (c) 2012 Agile Monks. All rights reserved.
//

#import "NSTimer+AMExtensions.h"
#import "AMBlockUtils.h"
#import <objc/runtime.h>

static char *myKey = "timerBlockKey";

@implementation NSTimer (AMExtensions)
+(void)amExecuteTimerBlock:(NSTimer*)timer
{
	
	BasicBlock1Arg block = objc_getAssociatedObject(timer, myKey);
	block(timer);
}

+(NSTimer*)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats 
							   usingBlock:(void (^)(NSTimer *timer))block
{
	NSTimer *t = [NSTimer scheduledTimerWithTimeInterval:seconds 
												  target:self 
												selector:@selector(amExecuteTimerBlock:) 
												userInfo:nil 
												 repeats:repeats];
	objc_setAssociatedObject(t, myKey, block, OBJC_ASSOCIATION_COPY);
	return t;
}

@end
