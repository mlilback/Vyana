//
//  NSString+AMExtensions.h
//
//  Created by Mark Lilback on Sun Jul 20 2003.
//  Copyright 2003-2011 Agile Monks, LLC. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: 4.1
//

#import <Foundation/Foundation.h>

@interface NSString(AMExtensions)
+(NSString*)stringWithUTF8Data:(NSData*)data;
///generates a UUID and returns it as a string
+(NSString*)stringWithUUID;
//generates a crypto hash of the string
-(NSString*)md5Hash;
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
-(NSString*)stringByRemovingLeadingArticle;
//removes any characters in cset
-(NSString*)stringByRemovingCharactersInCharacterSet:(NSCharacterSet*)cset;

//removes all characters except 0-9 A-Z a-z - _ 
-(NSString*)stringByRemovingNonSafeFileNameCharacters;

-(NSUInteger)countOfSubstring:(NSString*)str;

-(NSString*)stringByTrimmingWhitespace;
-(NSString*)stringbyRemovingPercentEscapes;

#if (__MAC_OS_X_VERSION_MIN_REQUIRED >= 1060)
-(NSString*)stringByEscapingXMLEntities;
-(NSString*)stringByUnescapingXMLEntities;
#endif
@end

@interface NSMutableString (AMExtensions)
#if (__MAC_OS_X_VERSION_MIN_REQUIRED >= 1060)
-(void)appendStringEscapingHTMLEntities:(NSString*)str;
#endif
@end
