//
//  AMNavigationTreeController.m
//  Vyana
//
//  Created by Mark Lilback on 1/31/12.
//  Copyright (c) 2012 Agile Monks. All rights reserved.
//

#import "AMBlockUtils.h"
#import "AMNavigationTreeController.h"
#import "AMNavigationTreeListController.h"

@interface AMNavigationTreeController()
@property (nonatomic, assign) BOOL delegateCreatesCells;
@property (nonatomic, strong) AMNavigationTreeListController *listController;
@end

@implementation AMNavigationTreeController

#pragma mark - View lifecycle

-(id)init
{
	if ((self = [super init])) {
		self.manageNavigationStack = YES;
	}
	return self;
}

- (void)loadView
{
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 500)];
	self.view = view;
	view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|
		UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|
		UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
	self.listController = [[AMNavigationTreeListController alloc] init];
	self.listController.view.frame = self.view.bounds;
	[self.view addSubview:self.listController.view];
	self.listController.treeController = self;
	if (self.tableSetupBlock)
		self.tableSetupBlock(self.listController.view);
}

- (void)viewDidUnload
{
	[super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(void)reloadData
{
	AMNavigationTreeListController *aListController = self.listController;
	if ([self.navigationController.topViewController isKindOfClass:[AMNavigationTreeListController class]])
		aListController = (id)self.navigationController.topViewController;
	[aListController reloadData];
}

#pragma mark - private methods for list class

-(UITableViewCell*)cellForItem:(id)item
{
	if (self.delegateCreatesCells)
		return [self.delegate navTree:self cellForItem:item];
	return nil;
}

#pragma mark - accessors

-(void)setDelegate:(id<AMNavigationTreeDelegate>)del
{
	_delegate = del;
	self.delegateCreatesCells = [del respondsToSelector:@selector(navTree:cellForItem:)];
}
@end
