//
//  AMRegExpFormatter.m
//  Vyana
//
//  Created by Mark Lilback on 10/28/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import "AMRegExpFormatter.h"

@implementation AMRegExpFormatter
-(id)initWithRegularExpression:(NSRegularExpression*)regex
{
	self = [super init];
	self.regex = regex;
	return self;
}

-(id)initWithRegularExpressionString:(NSString*)str
{
	NSError *err=nil;
	NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:str options:0 error:&err];
	ZAssert(re, @"invalid regular expression:%@", [err localizedDescription]);
	return [self initWithRegularExpression:re];
}

-(BOOL)isPartialStringValid:(NSString *)partialString 
		   newEditingString:(NSString **)newString 
		   errorDescription:(NSString **)error
{
	return [self.regex numberOfMatchesInString:partialString 
									   options:0 
										 range:NSMakeRange(0, [partialString length])];
}

-(NSString*)stringForObjectValue:(id)obj
{
	return obj;
}

-(BOOL)getObjectValue:(id *)obj forString:(NSString *)string errorDescription:(NSString **)error
{
	*obj = string;
	return YES;
}

@synthesize regex;
@end
