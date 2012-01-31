//
//  UIActionSheet+AMExtensions.h
//  Vyana
//
//  Created by Mark Lilback on 9/16/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIActionSheet (AMExtensions)
//actionItems should be an array of AMActionItem objects. 
// a delegate is created that will call the appropriate selector for the selected action item
// or do nothing on a button index < 0
-(id)initWithTitle:(NSString*)inTitle actionItems:(NSArray*)actionItems;
@end
