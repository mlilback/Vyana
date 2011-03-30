//
//  AMAppDefaults.h
//  Vyana
//
//  Created by Mark Lilback on 3/29/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMDefaultsSet;

@interface AMAppDefaults : NSObject {
	@private
}
+ (id)sharedInstance;

@property (nonatomic, readonly, copy) NSDictionary *propertySets;

-(AMDefaultsSet*)defaultsSetNamed:(NSString*)aSetName;

@end
