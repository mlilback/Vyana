//
//  AMCharacterSetFormatter.m
//  Vyana
//
//  Created by Mark Lilback on 10/28/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import "AMCharacterSetFormatter.h"

@interface AMCharacterSetFormatter()
@property (nonatomic, strong) NSCharacterSet *inverseCharSet;
@end

@implementation AMCharacterSetFormatter
@synthesize characterSet=__charSet;
@synthesize inverseCharSet;

-(NSString*)stringForObjectValue:(id)obj
{
	return obj;
}

-(BOOL)getObjectValue:(id *)obj forString:(NSString *)string errorDescription:(NSString **)error
{
	*obj = string;
	return YES;
}

-(BOOL)isPartialStringValid:(NSString *)partialString 
		   newEditingString:(NSString **)newString 
		   errorDescription:(NSString **)error
{
	NSRange rng = [partialString rangeOfCharacterFromSet:self.inverseCharSet];
	return rng.location == NSNotFound;
}

-(void)setCharacterSet:(NSCharacterSet *)characterSet
{
	__charSet = characterSet;
	self.inverseCharSet = [characterSet invertedSet];
}

@end
