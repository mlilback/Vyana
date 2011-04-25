//
//  iAMApplication.m
//  iMusicVideoPlayer
//
//  Created by Mark Lilback on 2/13/11.
//  Copyright 2011 Agile Monks, LLC. All rights reserved.
//

#import "iAMApplication.h"
#import "AMStateMachine.h"

#define kStatesKey @"states"
#define kCurStateKey @"curState"
#define kEventsKey @"events"

@interface iAMApplication()
@property (nonatomic, retain, readwrite) AMAppState *currentState;
@end

#pragma mark -

@implementation iAMApplication
-(id)init
{
	self = [super init];
	__pdata = [[NSMutableDictionary alloc] init];
	[__pdata setObject:[NSMutableArray array] forKey:kStatesKey];
	return self;
}

-(void)loadDefaultDefaults
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSURL *url = [[NSBundle mainBundle] URLForResource:@"DefaultDefaults" withExtension:@"plist"];
	NSDictionary *d = [NSDictionary dictionaryWithContentsOfURL:url];
	if (d)
		[defaults registerDefaults:d];	
}

#pragma mark - meat & potatoes
-(void)loadStateEngine
{
	NSURL *url = [[NSBundle mainBundle] URLForResource:@"AMAppStates" withExtension:@"plist"];
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfURL:url];
	if (nil == dict)
		[NSException raise:NSInvalidArgumentException format:@"Failed to find AMAppStates.plist"];
	//load states
	NSMutableDictionary *states = [NSMutableDictionary dictionary];
	for (NSString *str in [dict objectForKey:@"states"])
		[states setObject:[AMAppState stateWithName:str] forKey:str];
	[__pdata setObject:[[states copy] autorelease] forKey:kStatesKey];
	ZAssert([states count] > 0, @"no states specified");
	self.currentState = [states objectForKey:[dict objectForKey:@"initialState"]];
	ZAssert(self.currentState, @"no intial state specified");
	//load transitions
	NSMutableSet *events = [NSMutableSet set];
	for (NSDictionary *tdict in [dict objectForKey:@"transitions"]) {
		AMStateTransition *aTrans = [[AMStateTransition alloc] init];
		aTrans.startState = [states objectForKey:[tdict objectForKey:@"start"]];
		aTrans.endState = [states objectForKey:[tdict objectForKey:@"end"]];
		aTrans.event = NSSelectorFromString([tdict objectForKey:@"event"]);
		aTrans.targetPath = [tdict objectForKey:@"target"];
		[aTrans.startState addTransition:aTrans];
		[events addObject:[tdict objectForKey:@"event"]];
	}
	[__pdata setObject:[NSSet setWithSet:events] forKey:kEventsKey];
	[AMAppState generateEventHandlers];
}

-(void)sendDelegateEventNotifications
{
	__iDelWantsLoopStart = [self.delegate respondsToSelector:@selector(eventLoopStarting:)];
	__iDelWantsLoopEnd = [self.delegate respondsToSelector:@selector(eventLoopComplete:)];
}

#pragma mark - event handling

- (BOOL)sendAction:(SEL)action to:(id)target from:(id)sender forEvent:(UIEvent *)event
{
	if ([[__pdata objectForKey:kEventsKey] containsObject:NSStringFromSelector(action)]) {
		//it is an event managed by the state machine. does the current state handle it?
		if ([self.currentState acceptsEventSelector:action]) {
			AMStateTransition *theTrans = [self.currentState transitionForSelector:action];
			[self.currentState performSelector:action withObject:sender];
			self.currentState = theTrans.endState;
			return YES;
		}
		//not supported by the current state
		if ([self.delegate respondsToSelector:@selector(illegalStateTransition:selector:)])
			[(id)self.delegate illegalStateTransition:self.currentState selector:action];
		else
			NSLog(@"unsupported event (%@) received by state %@", NSStringFromSelector(action), 
				  self.currentState.name);
		return NO;
	}
	//otherwise, let normal event handling take place
	return [super sendAction:action to:target from:sender forEvent:event];
}

- (void)sendEvent:(UIEvent *)event
{
	if (__iDelWantsLoopStart)
		[(id<iAMApplicationDelegate>)self.delegate  eventLoopStarting:event];
	[super sendEvent:event];
	if (__iDelWantsLoopEnd)
		[(id<iAMApplicationDelegate>)self.delegate  eventLoopComplete:event];
}

#pragma mark - accessors

-(AMAppState*)currentState
{
	return [__pdata objectForKey:kCurStateKey];
}

-(void)setCurrentState:(AMAppState *)aState
{
	NSLog(@"currentState set to %@", aState.name);
	[__pdata setObject:aState forKey:kCurStateKey];
}

-(NSArray*)states
{
	return [[[__pdata objectForKey:kStatesKey] copy] autorelease];
}


@end
