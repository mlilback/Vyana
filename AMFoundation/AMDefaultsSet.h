//
//  AMDefaultsSet.h
//  Vyana
//
//  Created by Mark Lilback on 3/29/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMDefaultsSet : NSObject {
}

//NOTE: this is not to be in the final public API. it is just a hack to get this working for me now
-(void)takePropertiesFromDict:(NSDictionary*)dict;

-(id)objectForKey:(NSString*)key;
-(NSInteger)integerForKey:(NSString*)key;
-(CGFloat)cgFloatForKey:(NSString*)key;
-(BOOL)boolForKey:(NSString*)key;

@end
