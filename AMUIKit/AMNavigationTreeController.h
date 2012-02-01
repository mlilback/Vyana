//
//  AMNavigationTreeController.h
//  Vyana
//
//  Created by Mark Lilback on 1/31/12.
//  Copyright (c) 2012 Agile Monks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMBlockUtils.h"

@protocol AMNavigationTreeDelegate;

@interface AMNavigationTreeController : UIViewController
@property (nonatomic, weak) id<AMNavigationTreeDelegate> delegate;
/** Uses KVO. If nil, uses the -description method. */
@property (nonatomic, copy) NSString *keyForCellText;
/** If nil, no image displayed */
@property (nonatomic, copy) NSString *keyForCellImage;
/** if YES, will display a checkmark accessory on the selected item */
@property (nonatomic, assign) BOOL tracksSelectedItem;
/** the selected item. set before  displaying to show the initial selection. */
@property (nonatomic, weak) id selectedItem;
/** If assigned, the 3 required delegate methods related to data will not be called.
 	Instead, these items will be displayed with no child. */
@property (nonatomic, strong) NSArray *contentItems;
/** A block that is passed each table view so you can set colors, boders, etc. */
@property (nonatomic, copy) BasicBlock1Arg tableSetupBlock;
@end

@protocol AMNavigationTreeDelegate <NSObject>

-(NSInteger)navTree:(AMNavigationTreeController*)navTree numberOfChildrenOfItem:(id)item;
-(id)navTree:(AMNavigationTreeController*)navTree childOfItem:(id)item atIndex:(NSInteger)index;

-(BOOL)navTree:(AMNavigationTreeController*)navTree isLeafItem:(id)item;


@optional
/** optionally provide a custom cell for a specfic item. */
-(UITableViewCell*)navTree:(AMNavigationTreeController*)navTree cellForItem:(id)item;
/** optionally customizes a cell before display */
-(void)navTree:(AMNavigationTreeController*)navTree willDisplayCell:(UITableViewCell*)cell forItem:(id)item;
/** called when the user taps a leaf item */
-(void)navTree:(AMNavigationTreeController*)navTree leafItemTouched:(id)item;

@end