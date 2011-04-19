//
//  AMStateTransition.h
//  Vyana
//
//  Created by Mark Lilback on 4/18/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMAppState;

@interface AMStateTransition : NSObject {
	@private
	SEL __event;
}
@property (nonatomic, retain) AMAppState *startState;
@property (nonatomic, retain) AMAppState *endState;
@property (nonatomic, assign) SEL event;
@end
