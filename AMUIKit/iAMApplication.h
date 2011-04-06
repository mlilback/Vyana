//
//  iAMApplication.h
//
//  Created by Mark Lilback on 2/13/11.
//  Copyright 2011 Agile Monks, LLC. All rights reserved.
//

@protocol iAMApplicationDelegate<UIApplicationDelegate>
-(void)eventLoopStarting:(UIEvent*)event;
-(void)eventLoopComplete:(UIEvent*)event;
@end


@interface iAMApplication : UIApplication {
	BOOL _iDelWantsLoopStart, _iDelWantsLoopEnd;
}
-(void)sendDelegateEventNotifications;
@end
