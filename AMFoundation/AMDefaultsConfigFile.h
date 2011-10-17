//
//  AMDefaultsConfigFile.h
//
//  Created by Mark Lilback on 3/29/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMDefaultsConfigFile : NSObject
-(id)initWithDictionary:(NSDictionary*)dict bundle:(NSBundle*)bundle;

@property(nonatomic, readonly) NSDictionary *configDictionary;
@property(nonatomic, retain) NSBundle *bundle;
@end
