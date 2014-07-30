//
//  NSColor+AMExtensions.h
//
//  Created by Mark Lilback on 7/8/2003.
//  Copyright (c) 2003-2011 Agile Monks, LLC. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: NA
//

#import <Cocoa/Cocoa.h>


@interface NSColor (AMExtentions)
//returns NSColor for Carbon RGBColor
+(NSColor*)colorWithRGBColor:(RGBColor*)rgbColor;

+(NSColor*)colorFromDefaultsWithKey:(NSString*)key;

+(NSColor*)colorWithRGBAValue:(uint32_t)rgba;

//returns a color based on a RRGGBB or RRGGBBAA value as used in HTML
+(NSColor*)colorWithHexString:(NSString*)hexString;
//return the color as a RRGGBB string
-(NSString*)hexString;
//return the color as a r,g,b,a string where each is in [0 255]
-(NSString*)rgbaString;
//this is for use with Quartz, but NSColor seems a fine place to put it
+(CGColorSpaceRef)genericRGBColorSpace;
+(CGColorRef)cgBlackColor;
+(CGColorRef)cgWhiteColor;

//returns a cg color.caller must release.
-(CGColorRef)createCGColorRef;
//returns an autoreleased cg color
-(CGColorRef)cgColorRef;
@end
