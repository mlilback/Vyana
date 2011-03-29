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
-(CGImageRef)createImageRef
{
	NSData * imageData = [self TIFFRepresentation];
	CGImageRef imageRef;
	if(!imageData) return nil;
	CGImageSourceRef imageSource = CGImageSourceCreateWithData((CFDataRef)imageData, NULL);
	imageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
	return imageRef;
}
@end
