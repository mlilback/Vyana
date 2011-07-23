//
//  AMZeroingWeakRef.h
//
//  Created by Michael Ash on 7/5/10.
//	overridden by mlilback to add support for dynamic properties on ref'd class
//

#import <Foundation/Foundation.h>

#if MACOSX_DEPLOYMENT_TARGET <= MAC_OS_X_VERSION_10_6
@interface AMZeroingWeakRef : NSObject
{
    id _target;
#if NS_BLOCKS_AVAILABLE
    void (^_cleanupBlock)(id target);
#endif
}

+ (BOOL)canRefCoreFoundationObjects;

+ (id)refWithTarget: (id)target;

- (id)initWithTarget: (id)target;

#if NS_BLOCKS_AVAILABLE
// cleanup block runs while the global ZWR lock is held
// so make it short and sweet!
// use GCD or something to schedule execution later
// if you need to do something that may take a while
//
// it is unsafe to call -target on the weak ref from
// inside the cleanup block, which is why the target
// is passed in as a parameter
// note that you must not resurrect the target at this point!
- (void)setCleanupBlock: (void (^)(id target))block;
#endif

- (id)target;

@end
#endif
