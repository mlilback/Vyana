//
//  NSApplication+AMExtensions.h
//
//  Created by Mark Lilback on 10/1/2010.
//  Copyright 2010-11 Agile Monks, LLC. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: NA
//

#import <Cocoa/Cocoa.h>


@interface NSApplication (AMExtensions)
///Returns the path to the folder this application should use in the user's application support folder.
-(NSString*)thisApplicationsSupportFolder;
///Returns the path to the folder this application should use in the user's caches folder.
-(NSString*)thisApplicationsCacheFolder;
@end
