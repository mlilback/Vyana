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

///if true, deselects selection when a touch does not happen over a row.
// fires off the tableView:didDeselectIndexRow: method and the selection did change notification
@property (nonatomic, assign) BOOL deselectOnTouchesOutsideCells;
@end
