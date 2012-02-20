//
//  AMKeyValueObserver.m
//  KVOManager
//
//  Created by Mark Lilback on 9/9/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import "AMKeyValueObserver.h"
#import "MAZeroingWeakRef.h"

@interface AMKeyValueObserver()
@property (nonatomic, copy) AMKVOBlock block;
@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, retain) MAZeroingWeakRef *objectRef;
@end

@implementation AMKeyValueObserver

+(AMKeyValueObserver*)observerWithObject:(id)anObject 
								 keyPath:(NSString*)aPath 
							 withOptions:(NSKeyValueObservingOptions)theOptions
						   observerBlock:(AMKVOBlock)block;
{
	return [[[AMKeyValueObserver alloc] initWithObject:anObject 
											   keyPath:aPath 
										   withOptions:theOptions 
										 observerBlock:block] autorelease];
}

-(id)initWithObject:(id)anObject 
			keyPath:(NSString*)aPath 
		withOptions:(NSKeyValueObservingOptions)theOptions
	  observerBlock:(AMKVOBlock)aBlock
{
	if ((self = [super init])) {
		self.keyPath = aPath;
		self.objectRef = [MAZeroingWeakRef refWithTarget:anObject];
		self.block = aBlock;
		[anObject addObserver:self forKeyPath:aPath options:theOptions context:nil];
	}
	return self;
}

-(void)dealloc
{
	[self.objectRef.target removeObserver:self forKeyPath:self.keyPath];
	self.keyPath=nil;
	self.block=nil;
	[super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)kpath ofObject:(id)obj change:(NSDictionary *)change context:(void *)context
{
	self.block(obj, kpath, change);
}

@synthesize keyPath;
@synthesize objectRef;
@synthesize block;

@end
