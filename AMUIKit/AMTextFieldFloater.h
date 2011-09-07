//
//  AMTextFieldFloater.h
//  Vyana
//
//  Created by Mark Lilback on 9/7/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMTextFieldFloater : NSObject<UITextFieldDelegate>
@property (nonatomic, assign) UIView *rootView;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) CGFloat minScrollFraction;
@property (nonatomic, assign) CGFloat maxScrollFraction;
-(id)initWithRootView:(UIView*)aView;

@end
