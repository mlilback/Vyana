//
//  AMNavigationTreeController.h
//  Vyana
//
//  Created by Mark Lilback on 1/31/12.
//  Copyright (c) 2012 Agile Monks. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AMNavigationTreeDelegate;

@interface AMNavigationTreeController : UIViewController
@property (nonatomic, weak) id<AMNavigationTreeDelegate> delegate;
@property (nonatomic, copy) NSString *keyForCellText;
@property (nonatomic, copy) NSString *keyForCellImage;
@end

@protocol AMNavigationTreeDelegate <NSObject>

-(NSInteger)navTree:(AMNavigationTreeController*)navTree numberOfChildrenOfItem:(id)item;
-(id)navTree:(AMNavigationTreeController*)navTree childOfItem:(id)item atIndex:(NSInteger)index;

-(BOOL)navTree:(AMNavigationTreeController*)navTree isLeafItem:(id)item;

-(void)navTree:(AMNavigationTreeController*)navTree leafItemTouched:(id)item;

@optional
-(UITableViewCell*)navTree:(AMNavigationTreeController*)navTree cellForItem:(id)item;

@end