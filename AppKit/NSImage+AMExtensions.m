//
//  NSImage+AMExtensions.m
//
//  Created by Mark Lilback on Sat Dec 11 2004.
//  Copyright 2004-2011 Agile Monks, LLC. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: NA
//

#import "NSImage+AMExtensions.h"


@implementation NSImage (AMExtensions)
+(NSImage*)imageWithData:(NSData*)data
{
	return [[[NSImage alloc] initWithData:data] autorelease];
}

+(NSImage*)imageWithView:(NSView*)view
{
	[view lockFocus];
	if ([view wantsLayer])
		[view.layer renderInContext:[[NSGraphicsContext currentContext] graphicsPort]];
	NSBitmapImageRep *bir = [[NSBitmapImageRep alloc] initWithFocusedViewRect:[view bounds]];
	[view unlockFocus];
	NSImage *img = [[NSImage alloc] initWithSize:view.bounds.size];
	[img addRepresentation:bir];
	[bir release];
	return [img autorelease];
}

-(NSImage*)imageScaledToWidth:(CGFloat)width
{
	NSRect destRect = NSMakeRect(0, 0, width, floor(self.size.height * width / self.size.width));
	return [self imageScaledToSize:destRect.size];
}

-(NSImage*)imageScaledToHeight:(CGFloat)height
{
	NSSize sz = NSMakeSize(floor(self.size.width * height / self.size.height), height);
	return [self imageScaledToSize:sz];
}

-(NSImage*)imageScaledToSize:(NSSize)size
{
	NSImage *destImg = [[[NSImage alloc] initWithSize:size] autorelease];
	NSAffineTransform *at = [NSAffineTransform transform];
	CGFloat heightFactor = size.height / self.size.height;
	CGFloat widthFactor = size.width / self.size.width;
	CGFloat scale = heightFactor > widthFactor ? widthFactor : heightFactor;
	[at scaleBy:scale];
	[destImg lockFocus];
	[[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationMedium];
	NSRect r = NSZeroRect;
	r.size = size;
	[self drawInRect:r 
			fromRect:NSMakeRect(0, 0, self.size.width, self.size.height) 
		   operation:NSCompositeSourceOver 
			fraction:1.0];
	[destImg unlockFocus];
	return destImg;
}

-(NSImage *)tintedImageWithColor:(NSColor *)tint
{
	NSSize size = [self size];
	NSRect imageBounds = NSMakeRect(0, 0, size.width, size.height);

	NSImage *copiedImage = [self copy];
	
	[copiedImage lockFocus];
	
	[tint set];
	NSRectFillUsingOperation(imageBounds, NSCompositeSourceAtop);
	
	[copiedImage unlockFocus];
	
	return [copiedImage autorelease];
}

-(NSData*)bitmapDataOfType:(NSBitmapImageFileType)bitmapType properties:(NSDictionary*)props
{
	NSBitmapImageRep *rep=nil;
	for (NSImageRep *irep in self.representations) {
		if ([irep isKindOfClass:[NSBitmapImageRep class]]) {
			rep = (id)irep;
			break;
		}
	}
	if (nil == rep) {
		//we need to create one
		rep = [NSBitmapImageRep imageRepWithData:[self TIFFRepresentation]];
	}
	return [rep representationUsingType:bitmapType properties:props];
}

-(NSData*)jpegDataWithCompressionPercent:(CGFloat)per
{
	NSDictionary *props = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:per]
													  forKey:NSImageCompressionFactor];
	return [self bitmapDataOfType:NSJPEGFileType properties:props];
}

-(NSData*)pngData
{
	return [self bitmapDataOfType:NSPNGFileType properties:nil];
}

-(CGImageRef)createImageRef
{
	NSData * imageData = [self TIFFRepresentation];
	CGImageRef imageRef;
	if(!imageData) return nil;
	CGImageSourceRef imageSource = CGImageSourceCreateWithData((CFDataRef)imageData, NULL);
	imageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
	CFRelease(imageSource);
	return (CGImageRef)[(id)imageRef autorelease];
}
@end
