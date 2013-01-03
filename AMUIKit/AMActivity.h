//
//  AMActivity.h
//  Vyana
//
//  Created by Mark Lilback on 1/3/13.
//  Copyright 2013 Agile Monks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMActivity : UIActivity

@property (nonatomic, copy) BOOL(^canPerformBlock)(NSArray *items);
@property (nonatomic, copy) void(^prepareBlock)(NSArray *items);

-(id)initWithActivityType:(NSString*)actType title:(NSString*)actTitle image:(NSString*)imageName;

@end
