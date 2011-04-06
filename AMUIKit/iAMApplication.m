//
//  iAMApplication.m
//  iMusicVideoPlayer
//
//  Created by Mark Lilback on 2/13/11.
//  Copyright 2011 Agile Monks, LLC. All rights reserved.
//

#import "iAMApplication.h"


@implementation iAMApplication
-(void)sendDelegateEventNotifications
{
	_iDelWantsLoopStart = [self.delegate respondsToSelector:@selector(eventLoopStarting:)];
	_iDelWantsLoopEnd = [self.delegate respondsToSelector:@selector(eventLoopComplete:)];
}
- (void)sendEvent:(UIEvent *)event
{
	if (_iDelWantsLoopStart)
		[(id<iAMApplicationDelegate>)self.delegate  eventLoopStarting:event];
	[super sendEvent:event];
	if (_iDelWantsLoopEnd)
		[(id<iAMApplicationDelegate>)self.delegate  eventLoopComplete:event];
}
@end
