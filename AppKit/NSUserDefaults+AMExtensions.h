//
//  NSUserDefaults+AMExtensions.h
//  Vyana
//
//  Created by Mark Lilback on 9/17/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSUserDefaults (AMExtensions)
-(id)unarchiveObjectForKey:(NSString*)key;
-(void)archiveObject:(id<NSCoding>)object forKey:(NSString*)key;
@end
