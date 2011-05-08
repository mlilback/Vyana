//
//  NSImage+AMExtensions.h
//
//  Created by Mark Lilback on Sat Dec 11 2004.
//  Copyright 2004-2011 Agile Monks, LLC. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: NA
//

#import <Cocoa/Cocoa.h>


@interface NSImage (AMExtensions)
//UIKit has this, why not AppKit?
+(NSImage*)imageWithData:(NSData*)data;
//returns an NSImage with the contents of the view, including any layers
+(NSImage*)imageWithView:(NSView*)view;
//returns new image tinted with the specified color
-(NSImage *)tintedImageWithColor:(NSColor *)tint;
//returns a CGImageRef that must be released. Uses the TIFF data
-(CGImageRef)createImageRef;

-(NSData*)bitmapDataOfType:(NSBitmapImageFileType)bitmapType properties:(NSDictionary*)props;
-(NSData*)jpegDataWithCompressionPercent:(CGFloat)percent;
-(NSData*)pngData;
@end
