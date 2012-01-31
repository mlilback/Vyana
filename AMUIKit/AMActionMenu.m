//
//  AMActionMenu.m
//  Vyana
//
//  Created by Mark Lilback on 7/7/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import "AMActionMenu.h"
#import "AMActionItem.h"

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

@interface AMActionMenu()
@property (nonatomic, strong) UIActionSheet *sheet;
-(void)setupActionSheet;
@end

@implementation AMActionMenu
@synthesize menuItems=_menuItems;
@synthesize sheet;

+(AMActionMenu*)actionMenuWithItems:(NSArray*)items
{
	AMActionMenu *am = [[AMActionMenu alloc] init];
	am.menuItems = items;
	return am;
}

-(void)showFromBarButtonItem:(UIBarButtonItem*)barItem
{
	BOOL isPhone = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone);
	if (nil == self.sheet)
		[self setupActionSheet];
	self.sheet.delegate = self;
	[self.sheet showFromBarButtonItem:barItem animated:isPhone];
}

-(void)setupActionSheet
{
	UIActionSheet *as = [[UIActionSheet alloc] init];
	as.actionSheetStyle = UIActionSheetStyleAutomatic;
	self.sheet = as;
	as.delegate = self;
	for (AMActionItem *aitem in self.menuItems)
		[as addButtonWithTitle:aitem.title];
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
		[as addButtonWithTitle:@"Cancel"];
		as.cancelButtonIndex = as.numberOfButtons - 1;
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == actionSheet.cancelButtonIndex) {
		[actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
	} else {
		AMActionItem *aitem = [self.menuItems objectAtIndex:buttonIndex];
		[aitem.target performSelector:aitem.action withObject:aitem.userInfo];
		[actionSheet dismissWithClickedButtonIndex:buttonIndex animated:NO];
	}
}

- (void)didPresentActionSheet:(UIActionSheet *)actionSheet
{
	NSLog(@"did present");
}

-(void)setMenuItems:(NSArray *)items
{
	_menuItems = [items copy];
	if (!self.sheet.visible)
		self.sheet=nil;
}

@end
