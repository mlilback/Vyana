//
//  UIAlertView+AMExtensions.m
//
//  Created by Mark Lilback on 4/5/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import "UIAlertView+AMExtensions.h"

@interface AMAlertViewDelegate :NSObject<UIAlertViewDelegate>
@property (nonatomic, copy) AMAlertViewCompletionBlock cblock;
@end

@implementation AMAlertViewDelegate
@synthesize cblock;

-(id)initWithBlock:(AMAlertViewCompletionBlock)ablock
{
	self = [super init];
	self.cblock = ablock;
	return self;
}
-(void)dealloc
{
	self.cblock=nil;
	[super dealloc];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex 
{
	if (self.cblock)
		self.cblock(alertView, buttonIndex);
	[self autorelease];
}
@end

@implementation UIAlertView(AMExtensions)
+(void)showAlertWithTitle:(NSString*)title message:(NSString*)message
{
	AMAlertViewDelegate *del = [[AMAlertViewDelegate alloc] initWithBlock:nil];
	UIAlertView *av = [[UIAlertView alloc] initWithTitle:title message:message delegate:del cancelButtonTitle:NSLocalizedString(@"Ok", @"") otherButtonTitles:nil, nil];
	av.delegate = del;
	[av show];
	[av autorelease];
}

//the second parameter is the button index that was clicked.
-(void)showWithCompletionHandler:(AMAlertViewCompletionBlock)cblock
{
	AMAlertViewDelegate *del = [[AMAlertViewDelegate alloc] initWithBlock:cblock];
	self.delegate = del;
	[self show];
}
@end
