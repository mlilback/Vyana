//
//  AMRoundedButton.m
//  Vyana
//
//  Created by Mark Lilback on 12/3/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import "AMRoundedButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation AMRoundedButton
-(void)setHighlighted:(BOOL)h
{
	[super setHighlighted:h];
	if (self.highlightedColor)
		self.layer.backgroundColor = h ? self.highlightedColor.CGColor : self.normalBackgroundColor.CGColor;
}

-(void)setSelected:(BOOL)s
{
	[super setSelected:s];
	if (self.selectedBackgroundColor)
		self.layer.backgroundColor = s ? self.selectedBackgroundColor.CGColor : self.normalBackgroundColor.CGColor;
}

@synthesize selectedBackgroundColor;
@synthesize normalBackgroundColor;
@synthesize highlightedColor;

@end
