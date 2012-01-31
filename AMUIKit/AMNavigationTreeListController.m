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

@implementation AMNavigationTreeListController
@synthesize treeController;
@synthesize rootItem;

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
	UITableView *tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, 500)];
	self.view = tv;
	tv.delegate = self;
	tv.dataSource = self;
	tv.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|
		UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|
		UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
	self.title = [self.rootItem valueForKeyPath:self.treeController.keyForCellText];
	self.navigationItem.leftBarButtonItems = self.treeController.navigationItem.leftBarButtonItems;
	self.navigationItem.rightBarButtonItems = self.treeController.navigationItem.rightBarButtonItems;
	self.toolbarItems = self.treeController.toolbarItems;
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - table view

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.treeController.delegate navTree:self.treeController 
						  numberOfChildrenOfItem:self.rootItem];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	id item = [self.treeController.delegate navTree:self.treeController 
										childOfItem:self.rootItem 
											atIndex:indexPath.row];
	UITableViewCell *cell = [self.treeController cellForItem:item];
	if (cell)
		return cell;

	cell = [(UITableView*)self.view dequeueReusableCellWithIdentifier:@"NavTreeLeafCell"];
	if (nil == cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
									  reuseIdentifier:@"NavTreeLeafCell"];
	}
	if (![self.treeController.delegate navTree:self.treeController isLeafItem:item])
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	else
		cell.accessoryType = UITableViewCellAccessoryNone;
	if (self.treeController.keyForCellText)
		cell.textLabel.text = [item valueForKeyPath:self.treeController.keyForCellText];
	if (self.treeController.keyForCellImage)
		cell.imageView.image = [item valueForKeyPath:self.treeController.keyForCellImage];
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	id item = [self.treeController.delegate navTree:self.treeController 
										childOfItem:self.rootItem 
											atIndex:indexPath.row];
	[self.treeController.delegate navTree:self.treeController leafItemTouched:item];
	if (![self.treeController.delegate navTree:self.treeController isLeafItem:item]) {
		//need to load a new instance on nav stack
		NSLog(@"step 1");
		AMNavigationTreeListController *childList = [[AMNavigationTreeListController alloc] init];
		childList.treeController = self.treeController;
		childList.rootItem = item;
		childList.contentSizeForViewInPopover = self.treeController.contentSizeForViewInPopover;
		NSLog(@"step 2");
		UINavigationController *navController = self.navigationController;
		if (nil == navController)
			navController = self.treeController.navigationController;
		NSLog(@"step 3");
		ZAssert(navController, @"wtf??");
		[navController pushViewController:childList animated:YES];
		NSLog(@"step 4");
	}
}

@end


