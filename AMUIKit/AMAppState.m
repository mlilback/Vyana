//
//  AMAppState.m
//  Vyana
//
//  Created by Mark Lilback on 4/18/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import "AMStateMachine.h"
#import "iAMApplication.h"
#import <objc/runtime.h>

#define kTransKey @"transitions"
#define kBlocksKey @"blocks"
#define kEventsKey @"events"

static void eventWrapper(id self, SEL _cmd, id evt);

static NSMutableSet *sEvents;

@implementation AMAppState
+(void)initialize
{
	sEvents = [[NSMutableSet alloc] init];
}
+(id)stateWithName:(NSString*)aName
{
	AMAppState *s = [[AMAppState alloc] init];
	s.name = aName;
	return [s autorelease];
}

- (id)init
{
	if ((self = [super init])) {
		__pdata = [[NSMutableDictionary alloc] init];
		[__pdata setObject:[NSMutableSet set] forKey:kTransKey];
		[__pdata setObject:[NSMutableDictionary dictionary] forKey:kBlocksKey];
		[__pdata setObject:[NSMutableSet set] forKey:kEventsKey];
	}
	return self;
}

- (void)dealloc
{
	self.name=nil;
	[__pdata release];__pdata=nil;
	[super dealloc];
}

-(NSSet*)transitions
{
	return [[[__pdata objectForKey:kTransKey] copy] autorelease];
}

-(AMStateTransition*)transitionForSelector:(SEL)action
{
	for (AMStateTransition *aTrans in [__pdata objectForKey:kTransKey]) {
		if (action == aTrans.event)
			return aTrans;
	}
	return nil;
}

-(void)setBlockForTransition:(AMStateTransition*)aTrans block:(AMStateTransitionBlock)aBlock
{
	AMStateTransitionBlock theBlock = [aBlock copy];
	NSMutableDictionary *blocks = [__pdata objectForKey:kBlocksKey];
	[blocks setObject:theBlock forKey:NSStringFromSelector(aTrans.event)];
	[theBlock release];
}

-(void)handleSelector:(SEL)sel fromObject:(id)sender
{
	NSString *str = NSStringFromSelector(sel);
	if ([[__pdata objectForKey:kEventsKey] containsObject:NSStringFromSelector(sel)]) {
		AMStateTransitionBlock theBlock = [[__pdata objectForKey:kBlocksKey] objectForKey:str];
		theBlock(sender);
	} else {
		//oops. badness
		NSLog(@"unsupported event (%@) received by state %@", str, self.name);
		id del = [[UIApplication sharedApplication] delegate];
		if ([del respondsToSelector:@selector(illegalStateTransition:selector:)])
			[del illegalStateTransition:self selector:sel];
	}
}

-(BOOL)acceptsEventSelector:(SEL)sel
{
	return [[__pdata objectForKey:kEventsKey] containsObject:NSStringFromSelector(sel)];
}

@synthesize name;
@end

@implementation AMAppState(AMPrivate)
+(void)generateEventHandlers
{
	for (NSString *str in sEvents) {
		SEL sel = NSSelectorFromString(str);
		class_addMethod(self, sel, (IMP)eventWrapper, "v@:@");
	}
}

-(void)addTransition:(AMStateTransition*)aTrans
{
	[[__pdata objectForKey:kTransKey] addObject:aTrans];
	[[__pdata objectForKey:kEventsKey] addObject:NSStringFromSelector(aTrans.event)];
	[sEvents addObject:NSStringFromSelector(aTrans.event)];
}
@end


static void eventWrapper(id self, SEL _cmd, id sender)
{
	[self handleSelector:_cmd fromObject:sender];
}
