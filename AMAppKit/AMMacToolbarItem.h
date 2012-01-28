//
//  AMMacToolbarItem.h
//  Vyana
//
//  Created by Mark Lilback on 10/14/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//This subclass resizes the images to be 16x16 in a 24x24 space.

@interface AMMacToolbarItem : NSToolbarItem
//will be called with the toolbar item as argument to adjust/validate custom view
@property (nonatomic, copy) BasicBlock1Arg validationBlock;
@end
