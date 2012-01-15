//
//  AMCustomDrawImageRep.m
//  Vyana
//
//  Created by Mark Lilback on 1/15/12.
//  Copyright (c) 2012 Agile Monks. All rights reserved.
//

#import "AMBlockUtils.h"
#import "AMCustomDrawImageRep.h"

@implementation AMCustomDrawImageRep

-(id)initWithDrawBlock:(BasicBlock1Arg)block
{
	if ((self = [super init])) {
		self.drawBlock = block;
	}
	return self;
}

//NSImageRep uses NSCopyObject, so have to force a copy
-(id)copyWithZone:(NSZone *)zone
{
	AMCustomDrawImageRep *copy = [super copyWithZone:zone];
	copy.drawBlock = self.drawBlock;
	return copy;
}

-(BOOL)draw
{
	if (self.drawBlock) {
		self.drawBlock(self);
		return YES;
	}
	return NO;
}

@synthesize drawBlock;
@end
