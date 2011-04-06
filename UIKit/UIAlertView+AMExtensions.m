//
//  UIAlertView+AMExtensions.m
//
//  Created by Mark Lilback on 4/5/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import "UIAlertView+AMExtensions.h"

@interface AMAlertViewDelegate :NSObject<UIAlertViewDelegate> {
	AMAlertViewCompletionBlock __cblock;
}
@end

@implementation AMAlertViewDelegate
-(id)initWithBlock:(AMAlertViewCompletionBlock)ablock
{
	self = [super init];
	__cblock = [ablock copy];
	return self;
}
-(void)dealloc
{
	[__cblock release];
	[super dealloc];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex 
{
	__cblock(alertView, buttonIndex);
	[self autorelease];
}
@end

@implementation UIAlertView(AMExtensions)
//the second parameter is the button index that was clicked.
-(void)showWithCompletionHandler:(AMAlertViewCompletionBlock)cblock
{
	AMAlertViewDelegate *del = [[AMAlertViewDelegate alloc] initWithBlock:cblock];
	self.delegate = del;
	[self show];
}
@end
