//
//  NSDictionary+AMExtensions.h
//
//  Created by Mark Lilback on Fri Nov 01 2002.
//  Copyright (c) 2002-2011 Agile Monks, LLC. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: 4.1
//

#import <Foundation/Foundation.h>

@interface NSDictionary(AMExtensions)
/**	Uses NSPropertyListSerialization to read the dictionary from the plist data. 
 	all objects are immutable */
+(id)dictionaryWithPropertyListData:(NSData*)data;
/**	Uses NSPropertyListSerialization to read the dictionary from the plist data. 
	all containers are mutable */
+(id)mutableDictionaryWithPropertyListData:(NSData*)data;
/** If any item conforms to NSMutableCopying, -mutableCopy is called.
	else, if conforms to NSCopying, -copy is called.
	otherwise, same item is placed in new dict */
-(NSDictionary*)deepCopy;
/** If the dictionary does not contain a value for the requested key, it returns the default value */
-(id)objectForKey:(NSString*)key replacingNilWith:(id)defaultValue;
/** Convience method for serializing to an XML property list. Asserts on an error. */
-(NSData*)xmlPropertyListData;
@end

@interface NSMutableDictionary(AMExtensions)
///inits self by adding each item in items keyed by valueForKey:keyName
-(id)initWithItems:(NSArray*)items usingKeyName:(NSString*)keyName;
///same as setObject:forKey: but if object is nil, ignores it instead of exception
-(void)setObjectIgnoringNil:(id)object forKey:(id)key;
@end
