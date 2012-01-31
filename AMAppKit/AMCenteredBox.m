//
//  AMCenteredBox.m
//  AMSharedCode
//
//  Created by Mark Lilback on Sun Jan 25 2004.
//  Copyright 2004-2010 Agile Monks, LLC. All rights reserved.
//

#import "AMCenteredBox.h"

@implementation AMCenteredBox
-(id)initWithFrame:(NSRect)f
{
	if ((self = [super initWithFrame: f])) {
		[self setBorderType: NSNoBorder];
		[self setTitle: @""];
		[self setTitlePosition: NSNoTitle];
		_centerHoriz = YES;
		_centerVert = YES;
	}
	return self;
}
-(void)awakeFromNib
{
	_centerHoriz = YES;
	_centerVert = YES;
	NSRect f = [self frame];
	_offsetFromTop = [[self superview] frame].size.height - f.origin.y - f.size.height;
}
-(void)viewDidMoveToSuperview
{
	NSRect f = [self frame];
	if (nil == [self superview])
		_offsetFromTop = 0;
	else
		_offsetFromTop = [[self superview] frame].size.height - f.origin.y - f.size.height;
}
- (void)resizeWithOldSuperviewSize:(NSSize)oldFrameSize 
{ 
	NSRect tRect=[self frame]; 
	NSRect tSuperRect=[[self superview] frame]; 

	if (_centerHoriz)
		tRect.origin.x=((long) (tSuperRect.size.width-tRect.size.width))/2; 
	if (_centerVert)
		tRect.origin.y=((long) (tSuperRect.size.height-tRect.size.height))/2; 
	else {
		tRect.origin.y = tSuperRect.size.height - _offsetFromTop - tRect.size.height;
	}

	[self setFrame:tRect]; 
} 

-(void)setCentersVertically:(BOOL)val 
{
	if (val != _centerVert) {
		_centerVert = val;
		[self resizeWithOldSuperviewSize: [[self superview] frame].size];
	}
}

-(void)setCentersHorizontally:(BOOL)val 
{
	if (val != _centerHoriz) {
		_centerHoriz = val;
		[self resizeWithOldSuperviewSize: [[self superview] frame].size];
	}
}
@synthesize centersVertically=_centerVert;
@synthesize centersHorizontally=_centerHoriz;

@end
