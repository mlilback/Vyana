//
//  AMKeyValueObserver.h
//  KVOManager
//
//  Created by Mark Lilback on 9/9/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^AMKVOBlock)(id object, NSString *keyPath, NSDictionary *change);

@interface AMKeyValueObserver : NSObject

+(AMKeyValueObserver*)observerWithObject:(id)anObject 
			keyPath:(NSString*)aPath 
		withOptions:(NSKeyValueObservingOptions)theOptions
	  observerBlock:(AMKVOBlock)block;

-(id)initWithObject:(id)anObject 
			keyPath:(NSString*)aPath 
		withOptions:(NSKeyValueObservingOptions)theOptions
	  observerBlock:(AMKVOBlock)block;

@end
