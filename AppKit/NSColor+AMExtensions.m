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
//returns a color based on a RRGGBB value as used in HTML
+(NSColor*)colorWithHexString:(NSString*)hexString
{
	unsigned ccode = 0;
	unsigned char redByte, greenByte, blueByte;
	
	if ([hexString length] != 6)
		return nil;

	NSScanner *scanner = [NSScanner scannerWithString:hexString];
	[scanner scanHexInt:&ccode];
	redByte = (unsigned char) (ccode >> 16);
	greenByte = (unsigned char) (ccode >> 8);
	blueByte = (unsigned char) (ccode);	//don't want the high bits
	return [NSColor colorWithCalibratedRed:(float)redByte/255.0
		green:(float)greenByte/255.0 blue:(float)blueByte/255.0 alpha:1.0];
}
+(NSColor*)colorFromDefaultsWithKey:(NSString*)key
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSData *data = [defaults objectForKey:key];
	return [NSUnarchiver unarchiveObjectWithData:data];
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
//return the color as a r,g,b,a string where each is in [0 255]
-(NSString*)rgbaString
{
	NSColor *rgbColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	int r, g, b, a;
	r = round(255*[rgbColor redComponent]);  g = round(255*[rgbColor greenComponent]);
	b = round(255*[rgbColor blueComponent]); a = round(255*[rgbColor alphaComponent]);
	return [NSString stringWithFormat:@"%ld,%ld,%ld,%ld", r, g, b, a];
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
