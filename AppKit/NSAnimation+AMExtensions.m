//
//  NSAnimation+AMExtensions.m
//
//  Created by Mark Lilback on 7/18/2010.
//  Copyright 2010-11 Agile Monks, LLC. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: NA
//

#import "NSAnimation+AMExtensions.h"

@implementation NSAnimation (AMExtensions)
//returns a shake animation with shakeCount=8, shakeDuration=0.5, and shakeVigor=0.05
+(CAKeyframeAnimation *)shakeAnimation:(NSRect)frame
{
	return [self shakeAnimation:frame shakeCount:8 shakeDuration:0.5f shakeVigor:0.05f];
}
//shakes like the login window does on an invalid password.
+(CAKeyframeAnimation *)shakeAnimation:(NSRect)frame shakeCount:(NSInteger)shakeCount
	shakeDuration:(CGFloat)shakeDuration shakeVigor:(CGFloat)shakeVigor
{
	CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animation];

	CGMutablePathRef shakePath = CGPathCreateMutable();
	CGPathMoveToPoint(shakePath, NULL, NSMinX(frame), NSMinY(frame));
	int index;
	for (index = 0; index < shakeCount; ++index)
	{
		CGPathAddLineToPoint(shakePath, NULL, NSMinX(frame) - frame.size.width * shakeVigor, NSMinY(frame));
		CGPathAddLineToPoint(shakePath, NULL, NSMinX(frame) + frame.size.width * shakeVigor, NSMinY(frame));
	}
	CGPathCloseSubpath(shakePath);
	shakeAnimation.path = shakePath;
	shakeAnimation.duration = shakeDuration;
	CGPathRelease(shakePath);
	return shakeAnimation;
}

@end
