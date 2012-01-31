//
//  NSTextField+AMExtensions.h
//  Vyana
//
//  Created by Mark Lilback on 1/19/12.
//  Copyright (c) 2012 Agile Monks. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface NSTextField (AMExtensions)
-(void)resizeFontToFitText:(CGFloat)minFontSize maxSize:(CGFloat)maxFontSize;
@end
