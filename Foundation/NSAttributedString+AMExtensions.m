//
//  NSAttributedString+AMExtensions.m
//
//  Created by Mark Lilback on 8/14/2010.
//  Copyright 2010-11 Agile Monks, LLC. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: 4.3
//

#import "NSAttributedString+AMExtensions.h"

@implementation NSAttributedString (AMExtensions)

+(id)attributedStringWithString:(NSString*)str attributes:(NSDictionary*)attrs
{
	return [[[[self class] alloc] initWithString:str attributes:attrs] autorelease];
}

#if (TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IPHONE))

+(NSAttributedString*)hyperlinkFromString:(NSString*)str toURL:(NSURL*)url
{
	NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString: str];
	NSRange range = NSMakeRange(0, [attrString length]);

	[attrString beginEditing];
	[attrString addAttribute:NSLinkAttributeName value:[url absoluteString] range:range];

	// make the text appear in blue
	[attrString addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:range];

	// next make the text appear with an underline
	[attrString addAttribute:
			NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSSingleUnderlineStyle] range:range];

	[attrString endEditing];
	return [attrString autorelease];
}
#endif

@end

@implementation NSMutableAttributedString (AMExtensions)
-(void)deleteAllCharacters
{
	[self deleteCharactersInRange:NSMakeRange(0, [self length])];
}
-(void)appendString:(NSString*)string
{
	if (string)
		[[self mutableString] appendString:string];
}
-(void)appendString:(NSString*)string withAttributes:(NSDictionary*)attrs
{
	NSAttributedString *astr = [[NSAttributedString alloc] initWithString:string attributes:attrs];
	[self appendAttributedString:astr];
}
@end
