//
//  NSMenu+AMExtensions.h
//  Vyana
//
//  Created by Mark Lilback on 10/5/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import <AppKit/AppKit.h>

/** Convinence methods on NSMenu */
@interface NSMenu (AMExtensions)
/** Stores a representedObject ala NSMenuItem. Useful for contextual menus. */
@property (nonatomic, weak) id representedObject AVAILABLE_MAC_OS_X_VERSION_10_7_AND_LATER;
/** Recursively finds the first item with the specified tag in a width-first traversal */
-(NSMenuItem*)deepItemWithTag:(NSInteger)tag;
@end
