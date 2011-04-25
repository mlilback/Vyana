//
//  iAMApplication.h
//
//  Created by Mark Lilback on 2/13/11.
//  Copyright 2011 Agile Monks, LLC. All rights reserved.
//

@class AMAppState;

@protocol iAMApplicationDelegate<UIApplicationDelegate>
@optional
-(void)eventLoopStarting:(UIEvent*)event;
-(void)eventLoopComplete:(UIEvent*)event;
-(void)illegalStateTransition:(AMAppState*)state selector:(SEL)sel;
@end

@interface iAMApplication : UIApplication {
	@private
	id __pdata;
	BOOL __iDelWantsLoopStart, __iDelWantsLoopEnd;
}
@property (nonatomic, retain, readonly) AMAppState *currentState;
@property (nonatomic, readonly) NSArray *states;
-(void)sendDelegateEventNotifications;
//called to load AMAppStates.plist and initialize the state engine
-(void)loadStateEngine;

//unfortunately, there is no legal place to hook into UIApplication to perform this. So delegate must call it
-(void)loadDefaultDefaults;
@end
