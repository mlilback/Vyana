//
//  AMActionItem.h
//  Vyana
//
//  Created by Mark Lilback on 7/7/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMActionItem : NSObject {
}
+(AMActionItem*)actionItemWithName:(NSString*)inTitle target:(id)inTarget action:(SEL)inAction
						  userInfo:(id)userInfo;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, retain) id userInfo;

//used by views that hold action items. simply class the action on target with self as sender
-(void)performAction:(id)sender;
@end
