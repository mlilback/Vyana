//
//  NSTabView+AMExtensions.m
//  Vyana
//
//  Created by Mark Lilback on 1/18/12.
//  Copyright (c) 2012 Agile Monks. All rights reserved.
//

#import "NSTabView+AMExtensions.h"

@implementation NSTabView (AMExtensions)
-(NSTabViewItem*)tabViewItemWithIdentifier:(NSString*)identifier
{
	NSInteger idx = [self indexOfTabViewItemWithIdentifier:identifier];
	if (NSNotFound == idx)
		return nil;
	return [self tabViewItemAtIndex:idx];
}
@end
