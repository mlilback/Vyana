//
//  AMWindow.h
//  Vyana
//
//  Created by Mark Lilback on 10/16/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/** @class AMWindow
 */

@interface AMWindow : NSWindow
@property (nonatomic, unsafe_unretained) IBOutlet NSWindowController *windowController;
@end
