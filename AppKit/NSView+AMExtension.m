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
@end
