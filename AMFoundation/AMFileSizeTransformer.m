//
//  AMFileSizeTransformer.m
//
//  Created by Mark Lilback on 1/29/2010.
//  Copyright 2010-11 Agile Monks, LLC. All rights reserved.
//

#import "AMFileSizeTransformer.h"


@implementation AMFileSizeTransformer
+(Class)transformedValueClass
{
	return [NSString class];
}
+(BOOL)allowsReverseTransformation
{
	return NO;
}
-(id)transformedValue:(id)value 
{
	unsigned long long numbytes = [value unsignedLongLongValue];
	if (numbytes == 0)
		return @"0";
	if (numbytes < 1024)
		return [NSString stringWithFormat: @"%qi bytes", numbytes];
	else if (numbytes < 1048567)
		return [NSString stringWithFormat: @"%1.2f KB", numbytes/1024.0];
	else if (numbytes < 1073741824)
		return [NSString stringWithFormat: @"%1.2f MB", numbytes/1048567.0];
	else
		return [NSString stringWithFormat: @"%1.2f GB", numbytes/1073741824.0];
}

@end
