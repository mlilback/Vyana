//
//  AMColor.h
//  Vyana
//
//  Created by Mark Lilback on 3/11/13.
//  Copyright 2013 Agile Monks. All rights reserved.
//


@interface AMColor : NSObject

+(id)colorWithHexString:(NSString*)hexStr;
+(id)colorWithColor:(id)sysColor;


-(id)initWithHexString:(NSString*)hexStr;
-(id)initWithColor:(id)sysColor;

-(id)colorWithAlpha:(CGFloat)alpha;

-(CGColorRef)CGColor;

@property (strong, readonly) id nativeColor;
@end
