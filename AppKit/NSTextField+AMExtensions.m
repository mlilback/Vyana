//
//  NSTextField+AMExtensions.m
//  Vyana
//
//  Created by Mark Lilback on 1/19/12.
//  Copyright (c) 2012 Agile Monks. All rights reserved.
//

#import "NSTextField+AMExtensions.h"

@implementation NSTextField (AMExtensions)
+(instancetype)labelTextFieldWithFrame:(NSRect)frame
{
	NSTextField *label = [[NSTextField alloc] initWithFrame:frame];
	[label setBezeled:NO];
	[label setDrawsBackground:NO];
	[label setEditable:NO];
	[label setSelectable:NO];
	return label;
}

-(void)resizeFontToFitText:(CGFloat)minFontSize maxSize:(CGFloat)maxFontSize
{
	NSRect r = NSInsetRect(self.frame, 1, 1);
	NSString *fontName = self.font.fontName;
	NSString *string = self.stringValue;
	if (string.length < 1)
		return;
	int i;
	NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
	for (i=maxFontSize; i>=minFontSize; i--) {
		[attrs setObject:[NSFont fontWithName:fontName size:i] forKey:NSFontAttributeName];
		NSSize strSize = [string sizeWithAttributes:attrs];
		if (strSize.width <= r.size.width && strSize.height <= r.size.height) break;
	}
	[self setFont:[NSFont fontWithName:fontName size:i]];
}
@end
