//
//  AMActionMenu.h
//  Vyana
//
//  Created by Mark Lilback on 7/7/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

/*
 menuItems should be an array of AMActionItem objects
 */


@interface AMActionMenu : UIViewController<UIActionSheetDelegate>

+(AMActionMenu*)actionMenuWithItems:(NSArray*)items;

-(void)showFromBarButtonItem:(UIBarButtonItem*)barItem;

@property (nonatomic, copy) NSArray *menuItems;

@end
