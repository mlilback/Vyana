//
//  AMPromptView.h
//  iMusicVideoPlayer
//
//  Created by Mark Lilback on 2/3/11.
//  Copyright 2011 Agile Monks, LLC. All rights reserved.
//

/*
	As opposed to the delegate used by UIAlertView, this class uses a completion
	handler block. It will be called with a nil value if cancel was selected.
*/

@interface AMPromptView : UIAlertView {
	UITextField *textField;
}
-(id)initWithPrompt:(NSString*)prompt acceptTitle:(NSString*)acceptTitle
	cancelTitle:(NSString*)cancelTitle delegate:(id)delegate;

@property (nonatomic, readonly) NSString *enteredText;
@end
