//
//  AMApplication.h
//
//  Created by Mark Lilback on 3/27/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: NA
//

#import <Foundation/Foundation.h>

//This subclass will automatically register default defaults from a resource file
// called DefaultDefaults.plist if it exists.

@interface AMApplication : NSApplication {
}
-(void)loadFScriptIfAvailable;
@property (nonatomic, readonly) BOOL isTerminating;
@end
