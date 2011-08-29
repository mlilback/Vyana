//
//  AMActionMenu.m
//  Vyana
//
//  Created by Mark Lilback on 7/7/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import "AMActionMenu.h"
#import "AMActionItem.h"

#define BUTTON_HEIGHT 44
#define BUTTON_VMARGIN 4
#define BUTTON_HMARGIN 4

@interface AMActionMenu()
-(void)setupView:(UIView*)v;
-(CGRect)caclulateMenuFrame;
@end

@implementation AMActionMenu

+(AMActionMenu*)actionMenuWithItems:(NSArray*)items
{
	AMActionMenu *am = [[[AMActionMenu alloc] init] autorelease];
	am.menuItems = items;
	return am;
}

- (void)dealloc
{
	self.menuItems=nil;
	[super dealloc];
}

-(void)loadView
{
	UIView *v = [[UIView alloc] initWithFrame:[self caclulateMenuFrame]];
	self.view = v;
	[v release];
	[self setupView:v];
	self.contentSizeForViewInPopover = v.frame.size;
}

-(void)setupView:(UIView*)v
{
	NSArray *oldViews = [[self.view.subviews copy] autorelease];
	for (UIView *aView in oldViews)
		[aView removeFromSuperview];
	CGRect frame = CGRectMake(BUTTON_HMARGIN/2, BUTTON_VMARGIN/2, v.frame.size.width-BUTTON_HMARGIN, BUTTON_HEIGHT);
	for (NSInteger i=0; i < [self.menuItems count]; i++) {
		AMActionItem *item = [self.menuItems objectAtIndex:i];
		UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		button.frame = frame;
		[self.view addSubview:button];
		[button setTitle:item.title forState:UIControlStateNormal];
		button.titleLabel.font = [button.titleLabel.font fontWithSize:18];
		[button addTarget:item action:@selector(performAction:) forControlEvents:UIControlEventTouchUpInside];
		frame.origin.y += BUTTON_VMARGIN + BUTTON_HEIGHT;
	}
}

-(CGRect)caclulateMenuFrame
{
	CGFloat width=0;
	UIFont *fnt = [UIFont systemFontOfSize:18];
	for (AMActionItem *item in self.menuItems) {
		CGSize s = [item.title sizeWithFont:fnt];
		if (s.width > width)
			width = s.width;
	}
	if (width < 260)
		width = 260;
	CGRect r = CGRectMake(0, 0, width + BUTTON_HMARGIN, (BUTTON_HEIGHT + BUTTON_VMARGIN) * [self.menuItems count]);
	return r;
}

-(void)setMenuItems:(NSArray *)mi
{
	if (mi == __items)
		return;
	[__items release];
	__items = [mi copy];
	self.view.frame = [self caclulateMenuFrame];
	[self setupView:self.view];
}

@synthesize menuItems=__items;

@end
