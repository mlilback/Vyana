//
//  AMPromptView.m
//  iMusicVideoPlayer
//
//  Created by Mark Lilback on 2/3/11.
//  Copyright 2011 Agile Monks, LLC. All rights reserved.
//

#import "AMPromptView.h"


@implementation AMPromptView
-(id)initWithPrompt:(NSString*)prompt acceptTitle:(NSString*)acceptTitle
	cancelTitle:(NSString*)cancelTitle delegate:(id)delegate
{
	if ((self = [super initWithTitle:prompt message:@"\n\n" delegate:delegate
		cancelButtonTitle:cancelTitle otherButtonTitles:acceptTitle, nil]))
	{
		textField = [[UITextField alloc] initWithFrame:CGRectMake(12.0f, 45.0f, 260.0f, 31.0f)];
		[textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
		[textField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
		[textField setBorderStyle:UITextBorderStyleRoundedRect];
		[textField setBackgroundColor:[UIColor clearColor]];
		[textField setTextAlignment:UITextAlignmentCenter];
		textField.delegate = (id)self;
		[self addSubview:textField];
	}
	return self;
}

-(void)dealloc
{
	[textField release];
	[super dealloc];
}

-(void)show
{
	[textField becomeFirstResponder];
	[super show];
}

-(NSString*)enteredText
{
	return textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self dismissWithClickedButtonIndex:1 animated:YES];
	[self.delegate alertView:self clickedButtonAtIndex:1];
	return YES;
}
@end
