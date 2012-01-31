//
//  AMCustomDrawImageRep.h
//  Vyana
//
//  Created by Mark Lilback on 1/15/12.
//  Copyright (c) 2012 Agile Monks. All rights reserved.
//
// Based on NoodleCustomImageRep from <https://github.com/MrNoodle/NoodleKit>

#import <AppKit/AppKit.h>

@interface AMCustomDrawImageRep : NSImageRep
//the argument will be the image rep
@property (nonatomic, copy) BasicBlock1Arg drawBlock;

-(id)initWithDrawBlock:(BasicBlock1Arg)block;
@end
