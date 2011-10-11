//
//  UIApplication+AMExtensions.h
//  Vyana
//
//  Created by Mark Lilback on 10/11/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (AMExtensions)
///Returns the path to the folder this application should use in the user's application support folder.
-(NSString*)thisApplicationsSupportFolder;
///Returns the path to the folder this application should use in the user's caches folder.
-(NSString*)thisApplicationsCacheFolder;
@end
