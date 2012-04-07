//
//  UIActionSheet+AMExtensions.m
//  Vyana
//
//  Created by Mark Lilback on 9/16/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import "UIActionSheet+AMExtensions.h"
#import "AMActionItem.h"

@interface AMActionSheetActionItemDelegate : NSObject<UIActionSheetDelegate>
@property (nonatomic, copy) NSArray *actionItems;
-(id)initWithActionItems:(NSArray*)items;
@end

@implementation UIActionSheet (AMExtensions)
-(id)initWithTitle:(NSString*)inTitle actionItems:(NSArray*)actionItems
{
	AMActionSheetActionItemDelegate *del = [[AMActionSheetActionItemDelegate alloc] initWithActionItems:actionItems];
	self = [self initWithTitle:inTitle delegate:del cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
	for (AMActionItem *action in actionItems)
		[self addButtonWithTitle:action.title];	
	//we don't release the delegate. it releases itself in the delegate method
	return self;
}
@end

@implementation AMActionSheetActionItemDelegate
@synthesize actionItems;

-(id)initWithActionItems:(NSArray*)items
{
	self = [super init];
	self.actionItems = items;
	return self;
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex < 0)
		return;
	AMActionItem *action = [self.actionItems objectAtIndex:buttonIndex];
	dispatch_async(dispatch_get_main_queue(), ^{
		[action.target performSelector:action.action withObject:action];
	});
	actionSheet.delegate=nil;
	//autorelease wasn't being properly called for some reason. this does work.
	dispatch_async(dispatch_get_main_queue(), ^{
		[self release];
	});
}

-(void)dealloc
{
	self.actionItems=nil;
	[super dealloc];
}

@end
