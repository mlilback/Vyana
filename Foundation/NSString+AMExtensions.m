//
//  NSString+AMExtensions.m
//
//  Created by Mark Lilback on Sun Jul 20 2003.
//  Copyright 2003-2011 Agile Monks, LLC. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: 4.1
//

#import "NSString+AMExtensions.h"
#import <wchar.h>

@implementation NSString(AMExtensions)
+(NSString*)stringWithUTF8Data:(NSData*)data
{
	return [[[self alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
}
///generates a UUID and returns it as a string
+(NSString*)stringWithUUID
{
	CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
	NSString *uuidStr = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, uuid);
	CFRelease(uuid);
	return [uuidStr autorelease];
}

//find the first index matching the specified character, or NSNotFound if not found
-(NSUInteger)indexOfChar:(unichar)aChar
{
	NSUInteger i, c = [self length];
	for (i=0; i < c; i++)
		if ([self characterAtIndex: i] == aChar)
			return i;
	return NSNotFound;
}
//find the first index matching the specified string, or NSNotFound if not found
-(NSUInteger)indexOf:(NSString*)string
{
	NSRange rng = [self rangeOfString: string options: 0 
		range: NSMakeRange(0, [self length])];
	return rng.location;
}
//find the last index matching the specified character, or NSNotFound if not found
-(NSUInteger)lastIndexOfChar:(unichar)aChar
{
	NSInteger i;
	for (i=[self length]-1; i>= 0; i--)
		if ([self characterAtIndex: i] == aChar)
			return i;
	return NSNotFound;
}
//find the last index matching the specified string, or NSNotFound if not found
-(NSUInteger)lastIndexOf:(NSString*)string
{
	NSRange rng = [self rangeOfString: string options: NSBackwardsSearch 
		range: NSMakeRange(0, [self length])];
	return rng.location;
}

//returns YES if string contains any characters not in theSet
-(BOOL)containsCharacterNotInSet:(NSCharacterSet *)theSet
{
	NSUInteger i,c;
	for (i=0,c=[self length]; i < c; i++) {
		if (![theSet characterIsMember: [self characterAtIndex: i]])
			return YES;
	}
	return NO;
}

//compares numerically
-(NSComparisonResult)compareNumerically:(NSString*)str
{
	return [self compare: str options: NSNumericSearch range: NSMakeRange(0,[self length])
		locale: nil];
}

//used to find a matching parenthesis, bracket, etc. Returns NSNotFound if not found.
-(NSUInteger)indexOfClosingDelimiter:(unichar)closeDelim forOpeningDelimiter:(unichar)openDelim
	atIndex:(NSUInteger)openIndex
{
	NSUInteger stackCount = 0;
	NSUInteger idx;
	NSUInteger len = [self length];
	for (idx=openIndex+1; idx < len; idx++) {
		unichar c = [self characterAtIndex: idx];
		if (c == openDelim)
			stackCount++;
		else if (c == closeDelim) {
			if (stackCount == 0)
				return idx; //found closing delimiter
			stackCount--;
		}
	}
	return NSNotFound; //not found
}

//returns autoreleased string (might be self) with any CR, LF, or CFLF removed
-(NSString*)stringByRemovingTrailingEOL
{
	static NSCharacterSet *cs = nil;
	if (nil == cs)
		cs = [[[NSCharacterSet characterSetWithCharactersInString: @"\n\r"] invertedSet] retain];
	NSRange firstValid, lastValid;
	firstValid = [self rangeOfCharacterFromSet: cs];
	if (firstValid.length == 0)
		return self;
	lastValid = [self rangeOfCharacterFromSet: cs options: NSBackwardsSearch];
	if (firstValid.location == 0 && lastValid.location == [self length] - 1)
		return self;
	return [self substringWithRange: NSUnionRange(firstValid, lastValid)];
}
-(NSString*)replaceString:(NSString*)src withString:(NSString*)dest
{
	NSRange rng = [self rangeOfString: src];
	if (rng.location == NSNotFound)
		return self; //not found
	NSMutableString *outStr = [[self mutableCopy] autorelease];
	do {
		//want to replace r with a double single quote
		[outStr replaceCharactersInRange: rng withString: dest];
		//move range up past inserted string
		rng.location += [dest length];
		rng.length = [outStr length] - rng.location;
		//search for next match
		rng = [outStr rangeOfString: src options: 0 range: rng];
	} while (rng.location != NSNotFound);
	return [[outStr copy] autorelease];
}

-(NSUInteger)countOfSubstring:(NSString*)str
{
	NSUInteger cnt=0;
	NSRange searchRange = NSMakeRange(0, [self length]);
	NSRange fndRange;
	while ((fndRange = [self rangeOfString:str options:0 range:searchRange]).location != NSNotFound)
	{
		cnt++;
		searchRange.location = fndRange.location + fndRange.length;
		searchRange.length = [self length] - searchRange.location;
		if ((searchRange.length <= 0) || (searchRange.location > [self length]))
			break;
	}
	return cnt;
}

-(NSString*)stringByTrimmingWhitespace
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

//returns string with prefix of "A ", "An", or "The" removed
-(NSString*)stringByRemovingLeadingAritcle
{
	if ([[self lowercaseString] hasPrefix:@"a "])
		return [self substringFromIndex:2];
	if ([[self lowercaseString] hasPrefix:@"an "])
		return [self substringFromIndex:3];
	if ([[self lowercaseString] hasPrefix:@"the "])
		return [self substringFromIndex:4];
	return self;
}

-(NSString*)stringbyRemovingPercentEscapes
{
	NSString * newStr = (NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
															(CFStringRef) self,
															CFSTR(""),
															kCFStringEncodingUTF8);
	return [newStr autorelease];
}

#if (__MAC_OS_X_VERSION_MIN_REQUIRED >= 1060)
-(NSString*)stringByEscapingXMLEntities
{
	CFStringRef cfstr = CFXMLCreateStringByEscapingEntities(NULL, (CFStringRef)self, NULL);
	return [(id)cfstr autorelease];
}

-(NSString*)stringByUnescapingXMLEntities
{
	CFStringRef cfstr = CFXMLCreateStringByUnescapingEntities(NULL, (CFStringRef)self, NULL);
	return [(id)cfstr autorelease];
}
#endif
@end

@implementation NSMutableString (AMExtensions)
#if (__MAC_OS_X_VERSION_MIN_REQUIRED >= 1060)
-(void)appendStringEscapingHTMLEntities:(NSString*)str
{
	CFStringRef cfstr = CFXMLCreateStringByEscapingEntities(NULL, (CFStringRef)self, NULL);
	[self appendString:(NSString*)cfstr];
	CFRelease(cfstr);
}
#endif
@end
