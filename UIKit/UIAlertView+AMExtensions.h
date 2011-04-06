//
//  UIAlertView+AMExtensions.h
//  Vyana
//
//  Created by Mark Lilback on 4/5/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import <UIKit/UIKit.h>

//the second parameter is the button index that was clicked.
typedef void (^AMAlertViewCompletionBlock)(UIAlertView*, NSInteger);

@interface UIAlertView(AMExtensions)
-(void)showWithCompletionHandler:(AMAlertViewCompletionBlock)cblock;
@end
