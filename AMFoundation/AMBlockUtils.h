//
//  AMBlockUtils.h
//  Vyana
//
//  Created by Mark Lilback on 8/19/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^BasicBlock)(void);

void RunAfterDelay(NSTimeInterval delay, BasicBlock block);

@interface NSObject (BlocksAdditions)
- (void)my_callBlock;
@end
