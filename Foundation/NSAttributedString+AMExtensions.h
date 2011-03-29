//
//  NSAttributedString+AMExtensions.h
//
//  Created by Mark Lilback on 8/14/2010.
//  Copyright 2010-11 Agile Monks, LLC. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: 4.3
//

#import <Cocoa/Cocoa.h>

@interface NSAttributedString (AMExtensions)
+(id)attributedStringWithString:(NSString*)str attributes:(NSDictionary*)attrs;
#if (TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IPHONE))
+(NSAttributedString*)hyperlinkFromString:(NSString*)str toURL:(NSURL*)url;
#endif
@end

@interface NSMutableAttributedString (AMExtensions)
-(void)deleteAllCharacters;
-(void)appendString:(NSString*)string;
@end
