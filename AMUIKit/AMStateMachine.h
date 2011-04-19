//
//  AMStateMachine.h
//  Vyana
//
//  Created by Mark Lilback on 4/19/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMAppState.h"
#import "AMStateTransition.h"

@interface AMAppState(AMPrivate)
-(void)addTransition:(AMStateTransition*)aTrans;
+(void)generateEventHandlers;
@end
