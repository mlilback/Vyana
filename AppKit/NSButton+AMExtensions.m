//
//  NSButton+AMExtensions.m
//
//  Created by Mark Lilback on 9/23/2010.
//  Copyright 2011 Agile Monks, LLC. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: NA
//

#import "NSButton+AMExtensions.h"


@implementation NSButton (AMExtensions)
- (NSColor *)textColor
{
	NSAttributedString *attrTitle = [self attributedTitle];
	NSInteger len = [attrTitle length];
	NSRange range = NSMakeRange(0, MIN(len, 1)); // take color from first char
	NSDictionary *attrs = [attrTitle fontAttributesInRange:range];
	NSColor *textColor = [NSColor controlTextColor];
	if (attrs) {
		textColor = [attrs objectForKey:NSForegroundColorAttributeName];
	}
	return textColor;
}

- (void)setTextColor:(NSColor *)textColor
{
	NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] 
								 initWithAttributedString:[self attributedTitle]];
	NSInteger len = [attrTitle length];
	NSRange range = NSMakeRange(0, len);
	[attrTitle addAttribute:NSForegroundColorAttributeName 
					  value:textColor 
					  range:range];
	[attrTitle fixAttributesInRange:range];
	[self setAttributedTitle:attrTitle];
	[attrTitle release];
}

@end
