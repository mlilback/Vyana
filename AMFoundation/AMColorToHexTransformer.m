//
//  AMColorToHexTransformer.m
//  Vyana
//
//  Created by Mark Lilback on 4/9/12.
//  Copyright 2012 Agile Monks. All rights reserved.
//

#import "AMColorToHexTransformer.h"
#import "NSColor+AMExtensions.h"

@implementation AMColorToHexTransformer

+(Class)transformedValueClass
{
	return [NSColor class];
}

+(BOOL)allowsReverseTransformation
{
	return YES;
}

-(id)transformedValue:(id)value 
{
	if ([value isKindOfClass:[NSString class]])
		return [NSColor colorWithHexString:value];
	return [value hexString];
}

-(id)reverseTransformedValue:(id)value
{
	if ([value isKindOfClass:[NSColor class]])
		return [value hexString];
	return [NSColor colorWithHexString:value];
}

@end
