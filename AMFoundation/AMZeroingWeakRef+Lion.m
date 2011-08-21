//
//  AMZeroingWeakRef.m
//
//  Created by Michael Ash on 7/5/10.
//	overridden by mlilback to add support for dynamic properties on ref'd class
//

#import "AMZeroingWeakRef.h"
#import <objc/runtime.h>

@implementation AMZeroingWeakRef
+ (BOOL)canRefCoreFoundationObjects { return NO; }

+(id)refWithTarget:(id)target
{
	return [[[self alloc] initWithTarget:target] autorelease];
}
-(id)initWithTarget:(id)target
{
	self = [super init];
	objc_storeWeak(&_target, target);
	return self;
}
-(id)target 
{
	return objc_loadWeak(&_target);
}

- (void)setCleanupBlock: (void (^)(id target))block
{
}

@end
