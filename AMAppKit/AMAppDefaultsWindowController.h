//
//  AMAppDefaultsWindowController.h
//  Vyana
//
//  Created by Mark Lilback on 3/29/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AMAppDefaultsWindowController : NSWindowController<NSTableViewDelegate,NSTableViewDataSource> {
}
@property (nonatomic, assign) IBOutlet NSTableView *logTableView;
@property (nonatomic, copy) NSArray *logLevelNames;
@property (nonatomic, copy) NSArray *logLevelValues;
@property (nonatomic, copy) NSDictionary *logLevelNames2Ids;
@property (nonatomic, copy) NSDictionary *logLevels2Names;
@property (nonatomic, copy) NSArray *logClassNames;
@end
