//
//  NSAppleEventDescriptor+AMExtensions.h
//  Vyana
//
//  Created by Mark Lilback on 1/15/12.
//  Copyright (c) 2012 Agile Monks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAppleEventDescriptor (AMExtensions)
/**	Examines the number to use the best form possible (float, long, int, boolean, etc.) */
+(NSAppleEventDescriptor*)descriptorWithNumber:(NSNumber*)number;
/** Returns a descriptor of typeFileURL */
+(NSAppleEventDescriptor*)descriptorWithFileURL:(NSURL*)fileUrl;

/**	returns a record descriptor. Only converts objects of NSString, NSNumber, and NSAppleEventDescriptor. 
 Silently skips any other values. Keys must be strings or the value of description is used as the key. */
-(id)initWithDictionary:(NSDictionary*)dict;

/**	If the descriptor represents a numeric type, returns an appropriate NSNumber object */
-(NSNumber*)numberValue;
/** If descriptor is a file url, returns the file url value */
-(NSURL*)fileUrlValue;
@end
