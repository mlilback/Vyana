//
//  MNTAppDelegate.h
//  MacNavTest
//
//  Created by Mark Lilback on 11/16/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MNTAppDelegate : NSObject <NSApplicationDelegate,NSTableViewDataSource,NSTableViewDelegate>

@property (unsafe_unretained) IBOutlet NSWindow *window;
@property (nonatomic, strong) IBOutlet NSViewController *rootViewController;
@property (nonatomic, strong) IBOutlet NSTableView *masterTableView;
@property (nonatomic, strong) AMMacNavController *navController;

-(IBAction)back:(id)sender;
@end
