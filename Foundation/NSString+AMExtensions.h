//
//  NSString+AMExtensions.h
//
//  Created by Mark Lilback on Sun Jul 20 2003.
//  Copyright 2003-2011 Agile Monks, LLC. All rights reserved.
//


@interface NSString(AMExtensions)
+(NSString*)stringWithUTF8Data:(NSData*)data;
///find the first index matching the specified character, or NSNotFound if not found
-(NSUInteger)indexOfChar:(unichar)aChar;
///find the first index matching the specified string, or NSNotFound if not found
-(NSUInteger)indexOf:(NSString*)string;
///find the last index matching the specified character, or NSNotFound if not found
-(NSUInteger)lastIndexOfChar:(unichar)aChar;
///find the last index matching the specified string, or NSNotFound if not found
-(NSUInteger)lastIndexOf:(NSString*)string;
///returns YES if string contains any characters not in theSet
-(BOOL)containsCharacterNotInSet:(NSCharacterSet *)theSet;
///used to find a matching parenthesis, bracket, etc. Returns NSNotFound if not found.
-(NSUInteger)indexOfClosingDelimiter:(unichar)closeDelim forOpeningDelimiter:(unichar)openDelim
	atIndex:(NSUInteger)openIndex;
///returns autoreleased string (might be self) with any CR, LF, or CFLF removed
-(NSString*)stringByRemovingTrailingEOL;
///simple search and replace
-(NSString*)replaceString:(NSString*)src withString:(NSString*)dest;
///performs numeric comparison of entire string
-(NSComparisonResult)compareNumerically:(NSString*)str;
//returns string with prefix of "A ", "An", or "The" removed
-(NSString*)stringByRemovingLeadingAritcle;

-(NSUInteger)countOfSubstring:(NSString*)str;

-(NSString*)stringByTrimmingWhitespace;
-(NSString*)stringByEscapingXMLEntities;
-(NSString*)stringByUnescapingXMLEntities;
@end

@interface NSMutableString (AMExtensions)
-(void)appendStringEscapingHTMLEntities:(NSString*)str;
@end
