//
//  NSNumber+AMExtensions.h
//
//  Created by Mark Lilback on 2/10/11.
//  Copyright 2011 Agile Monks, LLC. All rights reserved.
//


@interface NSNumber (AMExtensions)

-(NSNumber*)numberByAddingInteger:(NSInteger)inc;
-(NSNumber*)numberBySubtractingInteger:(NSInteger)inc;
-(NSNumber*)numberByAddingCGFloat:(CGFloat)inc;
-(NSNumber*)numberBySubtractingCGFloat:(CGFloat)inc;

-(NSNumber*)numberWithCGFloat:(CGFloat)val;
-(CGFloat)cgFloatValue;

@end
