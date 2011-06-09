//
//  AMLabel.m
//
//  Created by Mark Lilback on 2/17/11.
//  Copyright 2011 Agile Monks, LLC. All rights reserved.
//

#import "AMLabel.h"


@implementation AMLabel

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame])) {
		self.verticalAlignment = VerticalAlignmentMiddle;
	}
	return self;
}
 
- (void)setVerticalAlignment:(VerticalAlignment)verticalAlignment
{
	_vertAlign = verticalAlignment;
	[self setNeedsDisplay];
}
 
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
	CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
	switch (self.verticalAlignment) {
		case VerticalAlignmentTop:
			textRect.origin.y = bounds.origin.y;
			break;
		case VerticalAlignmentBottom:
			textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
			break;
		case VerticalAlignmentMiddle:
			// Fall through.
		default:
			textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2;
	}
	return textRect;
}
 
-(void)drawTextInRect:(CGRect)requestedRect 
{
	CGRect actualRect = [self textRectForBounds:requestedRect 
							limitedToNumberOfLines:self.numberOfLines];
	[super drawTextInRect:actualRect];
}

@synthesize verticalAlignment=_vertAlign;
@end
