//
//  NSAttributedString-AMExtensions.h
//  Data Generator
//
//  Created by Mark Lilback on 8/14/2010.
//  Copyright 2010 Agile Monks, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSAttributedString (AMExtensions)
+(id)attributedStringWithString:(NSString*)str attributes:(NSDictionary*)attrs;
+(NSAttributedString*)hyperlinkFromString:(NSString*)str toURL:(NSURL*)url;
@end

@interface NSMutableAttributedString (AMExtensions)
-(void)deleteAllCharacters;
-(void)appendString:(NSString*)string;
@end
