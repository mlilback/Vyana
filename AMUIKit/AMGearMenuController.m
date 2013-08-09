//
//  GearMenuDelegate.m
//  iMusicVideoPlayer
//
//  Created by Mark Lilback on 2/8/11.
//  Copyright 2011 Agile Monks, LLC. All rights reserved.
//

#import "AMGearMenuController.h"

@interface AMGearMenuController () {
	BOOL _delegateCustomizes;
	BOOL _delegateSupportsSelectMethod;
}
@end

@implementation AMGearMenuController
@synthesize menuObjects=_objects;
@synthesize menuObjectTitleKey=_objKey;
@synthesize delegate=_delegate;
@synthesize selectedMenuObject=_selectedMenuObject;

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.clearsSelectionOnViewWillAppear=NO;
	self.contentSizeForViewInPopover = CGSizeMake(240,140);
//	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.bounces = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Override to allow orientations other than the default portrait orientation.
	return YES;
}

-(void)setMenuObjects:(NSMutableArray *)a
{
	if (a == _objects)
		return;
	[_objects release];
	_objects = [a mutableCopy];
	self.contentSizeForViewInPopover = CGSizeMake(240.0f, (CGFloat)fmin(400.0, [a count] * 44.0));
	[self.tableView reloadData];
}

-(void)setSelectedMenuObject:(id)selectedMenuObject
{
	if (_selectedMenuObject == selectedMenuObject)
		return;
	[_selectedMenuObject release];
	_selectedMenuObject = [selectedMenuObject retain];
	[self.tableView reloadData];
}

-(void)setDelegate:(id<AMGearMenuDelegate>)delegate
{
	_delegate = delegate;
	_delegateCustomizes = [delegate respondsToSelector:@selector(gearMenu:customizeCell:)];
	_delegateSupportsSelectMethod = [delegate respondsToSelector:@selector(gearMenuSelected:)];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	// Return the number of sections.
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// Return the number of rows in the section.
	return [self.menuObjects count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView 
	cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"GearMenuCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
			reuseIdentifier:CellIdentifier] autorelease];
	}
	id val = [self.menuObjects objectAtIndex:indexPath.row];
	if (val == self.selectedMenuObject)
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	else
		cell.accessoryType = UITableViewCellAccessoryNone;
	if ([val isKindOfClass:[AMGearMenuItem class]])
		val = [val title];
	else if (self.menuObjectTitleKey)
		val = [val valueForKey:self.menuObjectTitleKey];
	cell.textLabel.text = val;
	
	return cell;
}

#pragma mark -
#pragma mark Table view delegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (_delegateCustomizes)
		[self.delegate gearMenu:self customizeCell:cell];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	id obj = [self.menuObjects objectAtIndex:indexPath.row];
	self.selectedMenuObject = obj;
	if ([obj isKindOfClass:[AMGearMenuItem class]])
		[[obj target] performSelector:[(AMGearMenuItem*)obj action] withObject:obj];
	else if (self.delegate && _delegateSupportsSelectMethod)
		[self.delegate gearMenuSelected:obj];
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	[tableView reloadData];
}


- (void)dealloc
{
	self.menuObjects=nil;
	self.menuObjectTitleKey=nil;
	self.selectedMenuObject=nil;
	[super dealloc];
}

@end

#pragma mark -

@implementation AMGearMenuItem

+(AMGearMenuItem*)gearMenuItem:(NSString*)inTitle target:(id)inTarget action:(SEL)inAction
	userInfo:(id)inUserInfo
{
	AMGearMenuItem *gmi = [[[AMGearMenuItem alloc] init] autorelease];
	gmi.title = inTitle;
	gmi.action = inAction;
	gmi.target = inTarget;
	gmi.userInfo = inUserInfo;
	return gmi;
}
-(void)dealloc
{
	self.title = nil;
	[super dealloc];
}

@synthesize title;
@synthesize target;
@synthesize action;
@synthesize userInfo;
@end
