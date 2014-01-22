//
//  AMGenericTableViewHandler.m
//  Vyana
//
//  Created by Mark Lilback on 1/22/14.
//  Copyright 2014 Agile Monks. All rights reserved.
//

#import "AMGenericTableViewHandler.h"

@implementation AMGenericTableViewHandler

-(instancetype)initWithTableView:(UITableView*)tableView
{
	if ((self = [super init])) {
		self.theTableView = tableView;
	}
	return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.rowData.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return self.prepareCellBlock(self, tableView, indexPath);
}

-(void)setTheTableView:(UITableView *)theTableView
{
	_theTableView = theTableView;
	theTableView.delegate = self;
	theTableView.dataSource = self;
}

@end
