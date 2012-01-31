//
//  AMNavigationTreeListController.h
//  Vyana
//
//  Created by Mark Lilback on 1/31/12.
//  Copyright (c) 2012 Agile Monks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMNavigationTreeController;

@interface AMNavigationTreeListController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) AMNavigationTreeController *treeController;
@property (nonatomic, strong) id rootItem;
@end
