//
//  NSTimer+AMExtensions.h
//  Vyana
//
//  Created by Mark Lilback on 2/12/12.
//  Copyright (c) 2012 Agile Monks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (AMExtensions)
+(NSTimer*)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats 
								 usingBlock:(void (^)(NSTimer *timer))block;
@end
