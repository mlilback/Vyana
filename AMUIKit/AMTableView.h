//
//  AMTableView.h
//  Vyana
//
//  Created by Mark Lilback on 8/25/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMTableView;

typedef void (^TableEventBlock)(AMTableView *tv);


@interface AMTableView : UITableView
@property (nonatomic, copy) TableEventBlock doubleTapHandler;
@end
