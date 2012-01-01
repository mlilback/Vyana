//
//  UIImage+AMExtensions.h
//  Vyana
//
//  Created by Mark Lilback on 12/31/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AMExtensions)
-(UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
-(UIImage *)imageByScalingProportionallyToWidth:(CGFloat)targetWidth;
@end
