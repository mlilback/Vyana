//
//  NSAnimation+AMExtensions.h
//
//  Created by Mark Lilback on 7/18/2010.
//  Copyright 2010-11 Agile Monks, LLC. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: NA
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/CoreAnimation.h>


@interface NSAnimation (AMExtensions)
//returns a shake animation with shakeCount=8, shakeDuration=0.5, and shakeVigor=0.05
+(CAKeyframeAnimation *)shakeAnimation:(NSRect)frame;
//shakes like the login window does on an invalid password.
+(CAKeyframeAnimation *)shakeAnimation:(NSRect)frame shakeCount:(NSInteger)shakeCount
	shakeDuration:(CGFloat)shakeDuration shakeVigor:(CGFloat)shakeVigor;
@end
