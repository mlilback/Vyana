//
//  AMColorCell.m
//  AlliedProductEditor
//
//  Created by Mark Lilback on 10/11/2010.
//  Copyright 2010 Agile Monks, LLC. All rights reserved.
//

#import "AMColorCell.h"


@implementation AMColorCell
-(void)dealloc
{
	self.theColor=nil;
	[super dealloc];
}

-(NSColor*)theColor { return [self objectValue]; }
-(void)setTheColor:(NSColor *)aColor
{
	if (![NSCalibratedRGBColorSpace isEqualToString:[aColor colorSpaceName]])
		aColor = [aColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace]; 
	[self setObjectValue:aColor];
}
-(void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	[self.theColor set];
	cellFrame = NSInsetRect(cellFrame, 2, 2);
	NSRectFill(cellFrame);
}

@end
