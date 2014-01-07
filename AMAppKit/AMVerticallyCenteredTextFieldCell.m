//
//  AMVerticallyCenteredTextFieldCell.m
//  Vyana
//
//  Created by Mark Lilback on 1/7/14.
//  Copyright 2014 Agile Monks. All rights reserved.
//

#import "AMVerticallyCenteredTextFieldCell.h"

@interface AMVerticallyCenteredTextFieldCell()
@property (nonatomic) BOOL disableVerticalAdjustment;
@end

@implementation AMVerticallyCenteredTextFieldCell

-(NSRect)drawingRectForBounds:(NSRect)bounds
{
	NSRect newRect = [super drawingRectForBounds:bounds];
	//need to disable our magic when editing or selecting
	if (!self.disableVerticalAdjustment) {
		NSSize sz = [self cellSizeForBounds:bounds];
		CGFloat delta = newRect.size.height - sz.height;
		if (delta > 0) {
			newRect.size.height -= delta;
			newRect.origin.y += (delta/2);
		}
	}
	return newRect;
}

-(void)editWithFrame:(NSRect)frame inView:(NSView*)controlView editor:(NSText*)textObj delegate:(id)anObject event:(NSEvent*)theEvent
{
	frame = [self drawingRectForBounds:frame];
	self.disableVerticalAdjustment = YES;
	[super editWithFrame:frame inView:controlView editor:textObj delegate:anObject event:theEvent];
	self.disableVerticalAdjustment = NO;
}

-(void)selectWithFrame:(NSRect)frame inView:(NSView*)view editor:(NSText*)editor delegate:(id)delegate start:(NSInteger)selStart length:(NSInteger)selLength
{
	frame = [self drawingRectForBounds:frame];
	self.disableVerticalAdjustment = YES;
	[super selectWithFrame:frame inView:view editor:editor delegate:delegate start:selStart length:selLength];
	self.disableVerticalAdjustment = NO;
}

@end
