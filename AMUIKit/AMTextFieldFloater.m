//
//  AMTextFieldFloater.m
//  Vyana
//
//  Created by Mark Lilback on 9/7/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//
//	Based on code from <http://cocoawithlove.com/2008/10/sliding-uitextfields-around-to-avoid.html>

/*
 	A few issues here. There are notifications sent when the keyboard is displayed. we should
 	try using those to find out the size of the keyboard. there doesn't seem to be any other way,
 	and sizes can vary.
 */

#import "AMTextFieldFloater.h"

@interface AMTextFieldFloater() {
	CGFloat _animationDistance;
	UIView *_hostView;
	CGSize _keyboardSize;
}
-(void)keyboardWasShown:(NSNotification*)note;
-(void)keyboardWillHide:(NSNotification*)note;
@end

@implementation AMTextFieldFloater
 
@synthesize rootView;
@synthesize animationDuration;
@synthesize minScrollFraction;
@synthesize maxScrollFraction;

-(id)initWithRootView:(UIView*)aView
{
	if ((self = [super init])) {
		self.rootView = aView;
		self.minScrollFraction = 0.2f;
		self.maxScrollFraction = 0.8f;
		self.animationDuration = 0.3f;

		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWasShown:)
													 name:UIKeyboardDidShowNotification
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillHide:)
													 name:UIKeyboardWillHideNotification
												   object:nil];
	
	
	}
	return self;
}

-(void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

-(void)keyboardWasShown:(NSNotification*)note
{
	_keyboardSize = [[[note userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
}

-(void)keyboardWillHide:(NSNotification*)note
{
	
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
	_hostView = self.rootView;
	while (![_hostView.superview isKindOfClass:[UIWindow class]])
		_hostView = _hostView.superview;
	_hostView = self.rootView;
	UIWindow *window = textField.window;
	CGRect textFieldRect = [window convertRect:textField.bounds fromView:_hostView];
	CGFloat fieldBottom = textFieldRect.origin.y + CGRectGetMaxY(textField.frame) + 8;
	if (fieldBottom > _keyboardSize.height) {
		CGRect tfr = [window convertRect:textField.bounds fromView:textField];
		CGRect vr = [window convertRect:_hostView.bounds fromView:_hostView];
		CGFloat midline = tfr.origin.y + 0.5 * tfr.size.height;
		CGFloat numerator = midline - vr.origin.y - self.minScrollFraction * vr.size.height;
		CGFloat denominator = (self.maxScrollFraction - self.minScrollFraction) * vr.size.height;
		CGFloat heightFraction = numerator / denominator;
		if (heightFraction < 0.0)
			heightFraction = 0.0;
		if (heightFraction > 1.0)
			heightFraction = 1.0;
		_animationDistance = floor(_keyboardSize.height * heightFraction);
		CGRect viewFrame = _hostView.frame;
		viewFrame.origin.y -= _animationDistance;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:self.animationDuration];
		_hostView.frame = viewFrame;
		[UIView commitAnimations];
	} else {
		_animationDistance=0;
	}
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	if (_animationDistance > 0) {
		CGRect viewFrame = _hostView.frame;
		viewFrame.origin.y += _animationDistance;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:self.animationDuration];
		_hostView.frame = viewFrame;
		[UIView commitAnimations];
	}
}	

@end



