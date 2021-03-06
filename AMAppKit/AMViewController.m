//
//  AMViewController.m
//  Vyana
//
//  Created by Mark Lilback on 8/18/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import "AMViewController.h"
#import <objc/runtime.h>
#import "NSObject+BlockObservation.h"
#import "AMControlledView.h"

@interface AMVCBlockTokenWrapper : NSObject {
#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_7
	id _objWeakRef;
#endif
}
+(id)wrapperWithToken:(id)aToken forObject:(id)anObject;
@property (nonatomic, retain) id token;
@property (nonatomic, retain) id theObject;
@end

@interface AMViewController()
@property (nonatomic, retain) NSMutableArray *blockTokens;
@end

@implementation AMViewController

- (void)dealloc
{
	if ([self.view isKindOfClass:[AMControlledView class]]) {
		[((AMControlledView*)self.view) setViewController:nil];
	}
	[self releaseAllBlockTokens];
	[super dealloc];
}

-(void)viewWillMoveToSuperview:(NSView *)newSuperview
{
}

-(void)viewWillMoveToWindow:(NSWindow *)newWindow
{
}

-(void)viewDidMoveToWindow
{
}

-(void)viewDidMoveToSuperview
{
}

-(void)resizeSubviewsWithOldSize:(NSSize)oldBoundsSize
{
	
}

-(void)saveBlockToken:(id)aToken forObject:(id)obj
{
	if (nil == self.blockTokens)
		self.blockTokens = [[[NSMutableArray alloc] init] autorelease];
	[self.blockTokens addObject:[AMVCBlockTokenWrapper wrapperWithToken:aToken forObject:obj]];
}

-(void)releaseAllBlockTokens
{
	for (AMVCBlockTokenWrapper *aToken in self.blockTokens)
		[aToken.theObject removeObserverWithBlockToken:aToken.token];
}

@synthesize blockTokens;

@end

@implementation AMVCBlockTokenWrapper

+(id)wrapperWithToken:(id)aToken forObject:(id)anObject
{
	AMVCBlockTokenWrapper *w = [[[AMVCBlockTokenWrapper alloc] init] autorelease];
	w.token = aToken;
	w.theObject = anObject;
	return w;
}

-(id)theObject
{
	return objc_loadWeak(&_objWeakRef);
}
-(void)setTheObject:(id)obj
{
	objc_storeWeak(&_objWeakRef, obj);
}

@synthesize token;
@end

