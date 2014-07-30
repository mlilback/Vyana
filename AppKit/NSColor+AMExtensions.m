//
//  NSColor+AMExtensions.m
//
//  Created by Mark Lilback on 7/8/2003.
//  Copyright (c) 2003-2011 Agile Monks, LLC. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: NA
//

#import "NSColor+AMExtensions.h"


@implementation NSColor(AMExtensions)
//returns NSColor for Carbon RGBColor
+(NSColor*)colorWithRGBColor:(RGBColor*)rgbColor
{
	CGFloat r, g, b, maxv=UINT16_MAX;
	r = ((CGFloat)rgbColor->red) / maxv;
	g = ((CGFloat)rgbColor->green) / maxv;
	b = ((CGFloat)rgbColor->blue) / maxv;
	return [NSColor colorWithDeviceRed: r green: g blue: b alpha: (CGFloat)1.0];
}

+(NSColor*)colorWithHexString:(NSString*)hexString
{
	NSString *string = [hexString lowercaseString];
	if (![string isKindOfClass:[NSString class]])
		[NSException raise:NSInvalidArgumentException format:@"colorWithHexString: only accepts a string"];
	if ([string characterAtIndex:0] == '#')
		string = [hexString substringFromIndex:1];
	if ([string hasPrefix:@"0x"])
		string = [string substringFromIndex:2];
	if (string.length == 6)
		string = [string stringByAppendingString:@"ff"];
	if (string.length != 8)
		return nil;
	
	uint32_t rgba;
	NSScanner *scanner = [NSScanner scannerWithString:string];
	[scanner scanHexInt:&rgba];
	return [NSColor colorWithRGBAValue:rgba];
}

+(NSColor*)colorFromDefaultsWithKey:(NSString*)key
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSData *data = [defaults objectForKey:key];
	return [NSUnarchiver unarchiveObjectWithData:data];
}

+(NSColor*)colorWithRGBAValue:(uint32_t)rgba
{
	CGFloat red = ((rgba & 0xFF000000) >> 24) / 255.0;
	CGFloat green = ((rgba & 0x00FF0000) >> 16) / 255.0;
	CGFloat blue = ((rgba & 0x0000FF00) >> 8) / 255.0;
	CGFloat alpha = (rgba & 0x000000FF) / 255.0;
	return [NSColor colorWithRed:red green:green blue:blue alpha:alpha];
}

//return the color as a RRGGBB string
-(NSString*)hexString
{
	NSColor *rgbColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	return [NSString stringWithFormat:@"%02x%02x%02x", 
		(unsigned)([rgbColor redComponent]  *255.99999f),
		(unsigned)([rgbColor greenComponent]*255.99999f),
		(unsigned)([rgbColor blueComponent] *255.99999f)];
}

-(NSString*)hexStringWithAlpha
{
	CGFloat red, green, blue, alpha;
	[self getRed:&red green:&green blue:&blue alpha:&alpha];
	return [NSString stringWithFormat:@"%02x%02x%02x%02x",
			(unsigned)(red *255.99999f),
			(unsigned)(green*255.99999f),
			(unsigned)(blue *255.99999f),
			(unsigned)(alpha * 255.99999f)];
}

//return the color as a r,g,b,a string where each is in [0 255]
-(NSString*)rgbaString
{
	NSColor *rgbColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	int r, g, b, a;
	r = round(255*[rgbColor redComponent]);  g = round(255*[rgbColor greenComponent]);
	b = round(255*[rgbColor blueComponent]); a = round(255*[rgbColor alphaComponent]);
	return [NSString stringWithFormat:@"%d,%d,%d,%d", r, g, b, a];
}
//this is for use with Quartz, but NSColor seems a fine place to put it
+(CGColorSpaceRef)genericRGBColorSpace
{
	static CGColorSpaceRef space=nil;
	if (nil == space)
		space = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
	return space;
}
+(CGColorRef)cgBlackColor
{
	static CGColorRef black=nil;
	if (nil == black) {
		CGFloat values[4] = {0.0,0.0,0.0,1.0};
		black = CGColorCreate([self genericRGBColorSpace], values);
	}
	return black;
}
+(CGColorRef)cgWhiteColor
{
	static CGColorRef white=nil;
	if (nil == white) {
		CGFloat values[4] = {1.0,1.0,1.0,1.0};
		white = CGColorCreate([self genericRGBColorSpace], values);
	}
	return white;
}
-(CGColorRef)createCGColorRef
{
	NSColor *rgbColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	CGColorRef colorRef = CGColorCreateGenericRGB([rgbColor redComponent], 
		[rgbColor greenComponent], [rgbColor blueComponent], [rgbColor alphaComponent]);
	[(id)colorRef autorelease];
	return colorRef;
}

//returns an autoreleased cg color
-(CGColorRef)cgColorRef
{
	NSColor *rgbColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	CGColorRef cref = CGColorCreateGenericRGB([rgbColor redComponent], 
								   [rgbColor greenComponent], [rgbColor blueComponent], [rgbColor alphaComponent]);
	return (CGColorRef)[(id)cref autorelease];
}
@end
