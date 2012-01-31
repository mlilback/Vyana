//
//  AMNavigationTreeController.m
//  Vyana
//
//  Created by Mark Lilback on 1/31/12.
//  Copyright (c) 2012 Agile Monks. All rights reserved.
//

#import "AMNavigationTreeController.h"
#import "AMNavigationTreeListController.h"

@interface AMNavigationTreeController()
@property (nonatomic, assign) BOOL delegateCreatesCells;
@property (nonatomic, strong) AMNavigationTreeListController *listController;
@end

@implementation AMNavigationTreeController
@synthesize delegate=_delegate;
@synthesize delegateCreatesCells;
@synthesize keyForCellText;
@synthesize keyForCellImage;
@synthesize listController;

#pragma mark - View lifecycle

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