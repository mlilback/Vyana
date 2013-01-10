//
//  AMNavigationTreeListController.m
//  Vyana
//
//  Created by Mark Lilback on 1/31/12.
//  Copyright (c) 2012 Agile Monks. All rights reserved.
//

#import "AMNavigationTreeListController.h"
#import "AMNavigationTreeController.h"

@interface AMNavigationTreeController (AMPrivate)
-(UITableViewCell*)cellForItem:(id)item;
@end

@interface AMNavigationTreeListController()
@property (nonatomic, strong) UITableView *listTableView;
@end

@implementation AMNavigationTreeListController

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
	UITableView *tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, 500)];
	self.view = tv;
	self.listTableView = tv;
	tv.delegate = self;
	tv.dataSource = self;
	tv.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|
		UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|
		UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
	self.title = [self.rootItem valueForKeyPath:self.treeController.keyForCellText];
	self.navigationItem.leftBarButtonItems = self.treeController.navigationItem.leftBarButtonItems;
	self.navigationItem.rightBarButtonItems = self.treeController.navigationItem.rightBarButtonItems;
	self.toolbarItems = self.treeController.toolbarItems;
	if (self.treeController.tableSetupBlock)
		self.treeController.tableSetupBlock(tv);
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self.listTableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(void)reloadData
{
	[self.listTableView reloadData];
}

#pragma mark - table view

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (self.treeController.contentItems)
		return self.treeController.contentItems.count;
	return [self.treeController.delegate navTree:self.treeController 
						  numberOfChildrenOfItem:self.rootItem];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	id item=nil;
	UITableViewCell *cell=nil;
	BOOL haveContent = nil != self.treeController.contentItems;
	if (haveContent)
		item = [self.treeController.contentItems objectAtIndex:indexPath.row];
	else {
		item = [self.treeController.delegate navTree:self.treeController 
										 childOfItem:self.rootItem 
											 atIndex:indexPath.row];
	}
	cell = [self.treeController cellForItem:item];
	if (cell)
		return cell;

	cell = [(UITableView*)self.view dequeueReusableCellWithIdentifier:@"NavTreeLeafCell"];
	if (nil == cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
									  reuseIdentifier:@"NavTreeLeafCell"];
	}
	if (haveContent) {
		if (nil == self.treeController.keyForCellText)
			cell.textLabel.text = [item description];
		else
			cell.textLabel.text = [item valueForKeyPath:self.treeController.keyForCellText];
	} else {
		if (![self.treeController.delegate navTree:self.treeController isLeafItem:item])
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		else
			cell.accessoryType = UITableViewCellAccessoryNone;
		if (self.treeController.keyForCellText)
			cell.textLabel.text = [item valueForKeyPath:self.treeController.keyForCellText];
	}
	if (self.treeController.keyForCellImage)
		cell.imageView.image = [item valueForKeyPath:self.treeController.keyForCellImage];
	if (self.treeController.tracksSelectedItem && self.treeController.selectedItem == item)
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) //clear out any old checkmark
		cell.accessoryType = UITableViewCellAccessoryNone;
	
	if ([self.treeController.delegate respondsToSelector:@selector(navTree:willDisplayCell:forItem:)])
		[self.treeController.delegate navTree:self.treeController willDisplayCell:cell forItem:item];
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	BOOL haveContent = nil != self.treeController.contentItems;
	id item=nil;
	if (haveContent)
		item = [self.treeController.contentItems objectAtIndex:indexPath.row];
	else {
		item = [self.treeController.delegate navTree:self.treeController 
										 childOfItem:self.rootItem 
											 atIndex:indexPath.row];
	}
	self.treeController.selectedItem = item;
	if ([self.treeController.delegate respondsToSelector:@selector(navTree:leafItemTouched:)])
		[self.treeController.delegate navTree:self.treeController leafItemTouched:item];
	if (!haveContent && ![self.treeController.delegate navTree:self.treeController isLeafItem:item] && self.treeController.manageNavigationStack) {
		//need to load a new instance on nav stack
		AMNavigationTreeListController *childList = [[AMNavigationTreeListController alloc] init];
		childList.treeController = self.treeController;
		childList.rootItem = item;
		childList.contentSizeForViewInPopover = self.treeController.contentSizeForViewInPopover;
		UINavigationController *navController = self.navigationController;
		if (nil == navController)
			navController = self.treeController.navigationController;
		ZAssert(navController != nil, @"wtf??");
		[navController pushViewController:childList animated:YES];
	}
}

@end


