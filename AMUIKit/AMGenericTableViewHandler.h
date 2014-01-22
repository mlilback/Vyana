//
//  AMGenericTableViewHandler.h
//  Vyana
//
//  Created by Mark Lilback on 1/22/14.
//  Copyright 2014 Agile Monks. All rights reserved.
//

@interface AMGenericTableViewHandler : NSObject <UITableViewDataSource,UITableViewDelegate>
-(instancetype)initWithTableView:(UITableView*)tableView;

@property (nonatomic, copy) NSArray *rowData;
@property (nonatomic, weak) UITableView *theTableView; //optional use for owner
@property (nonatomic, copy) UITableViewCell* (^prepareCellBlock)(AMGenericTableViewHandler *handler, UITableView *table, NSIndexPath *indexPath);
@end
