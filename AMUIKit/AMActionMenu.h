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


@interface AMActionMenu : UIViewController {
	@private
	NSArray *__items;
}

+(AMActionMenu*)actionMenuWithItems:(NSArray*)items;

@property (nonatomic, copy) NSArray *menuItems;

@end
