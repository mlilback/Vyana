//
//  NSIndexPath+AMExtensions.m
//  AMSharedCode
//
//  Created by Mark Lilback on 2/3/11.
//  Copyright 2011 Agile Monks, LLC. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: 4.1
//

#import "NSIndexPath+AMExtensions.h"


@implementation NSIndexPath (AMExtensions)

+(NSIndexPath*)indexPathWithIndex:(NSUInteger)index index2:(NSUInteger)index2
{
	NSUInteger i[2];
	i[0] = index;
	i[1] = index2;
	return [NSIndexPath indexPathWithIndexes:i length:2];
}

@end
