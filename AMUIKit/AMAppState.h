//
//  AMAppState.h
//  Vyana
//
//  Created by Mark Lilback on 4/18/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMStateTransition;

typedef void (^AMStateTransitionBlock)(id);


@interface AMAppState : NSObject {
	@private
	id __pdata;
}
+(id)stateWithName:(NSString*)aName;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, readonly) NSSet *transitions;

-(void)setBlockForTransition:(AMStateTransition*)aTrans block:(AMStateTransitionBlock)aBlock;

-(AMStateTransition*)transitionForSelector:(SEL)action;

-(BOOL)acceptsEventSelector:(SEL)sel;
@end
