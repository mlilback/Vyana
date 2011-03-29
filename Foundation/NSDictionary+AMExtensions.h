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
//If any item conforms to NSMutableCopying, -mutableCopy is called.
// else, if conforms to NSCopying, -copy is called.
// otherwise, same item is placed in new dict
-(NSDictionary*)deepCopy;
@end

@interface NSMutableDictionary(AMExtensions)
//inits self by adding each item in items keyed by valueForKey:keyName
-(id)initWithItems:(NSArray*)items usingKeyName:(NSString*)keyName;
//same as setObject:forKey: but if object is nil, ignores it instead of exception
-(void)setObjectIgnoringNil:(id)object forKey:(id)key;
@end
