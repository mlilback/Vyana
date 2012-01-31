//
//  NSView+AMExtension.m
//  Vyana
//
//  Created by Mark Lilback on 9/27/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import "NSView+AMExtension.h"

@implementation NSView (AMExtension)
-(NSView*)firstAncestorOfClass:(Class)aClass
{
	NSView *parent = self;
	do {
		if ([parent isKindOfClass:aClass])
			return parent;
		parent = parent.superview;
	} while (parent);
	return nil;
}

- (NSImage *)imageWithSubviews
{
	NSSize mySize = self.bounds.size;
	NSSize imgSize = NSMakeSize( mySize.width, mySize.height );
	
	NSBitmapImageRep *bir = [self bitmapImageRepForCachingDisplayInRect:[self bounds]];
	[bir setSize:imgSize];
	[self cacheDisplayInRect:[self bounds] toBitmapImageRep:bir];
	
	NSImage* image = [[[NSImage alloc] initWithSize:imgSize] autorelease];
	[image addRepresentation:bir];
	return image;
}

-(void)removeAllSubviews
{
	while ([self.subviews count] > 0)
		[[self.subviews objectAtIndex:0] removeFromSuperview];
}

@end
