//
//  NSNumber+AMExtensions.m
//
//  Created by Mark Lilback on 2/10/11.
//  Copyright 2011 Agile Monks, LLC. All rights reserved.
//

#import "NSNumber+AMExtensions.h"

@implementation NSNumber(AMExtensions)

-(NSNumber*)numberByAddingInteger:(NSInteger)inc;
{
	return [NSNumber numberWithInteger:[self integerValue] + inc];
}

-(NSNumber*)numberBySubtractingInteger:(NSInteger)inc
{
	return [NSNumber numberWithInteger:[self integerValue] - inc];
}

-(NSNumber*)numberByAddingCGFloat:(CGFloat)inc
{
#if CGFLOAT_IS_DOUBLE
	return [NSNumber numberWithDouble:[self doubleValue] + inc];
#else
	return [NSNumber numberWithFloat:[self floatValue] + inc];
#endif
}

-(NSNumber*)numberBySubtractingCGFloat:(CGFloat)inc
{
#if CGFLOAT_IS_DOUBLE
	return [NSNumber numberWithDouble:[self doubleValue] - inc];
#else
	return [NSNumber numberWithFloat:[self floatValue] - inc];
#endif
}

-(NSNumber*)numberWithCGFloat:(CGFloat)val
{
#if CGFLOAT_IS_DOUBLE
	return [NSNumber numberWithDouble:val];
#else
	return [NSNumber numberWithFloat:val];
#endif
}

-(CGFloat)cgFloatValue
{
#if CGFLOAT_IS_DOUBLE
	return [self doubleValue];
#else
	return [self floatValue];
#endif
}

@end
