//
//  AMProgressWindowController.h
//
//  Created by Mark Lilback on 8/10/2010.
//  Copyright 2010-11 Agile Monks, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef void (^AMProgressCancelBlockType)(id);

//exposes "percentComplete" binding for 0..100 value to show in determinate indicator

/** A window controller for use as a sheet to show progress to the user,
	
	The basic steps to use this class are:
		-# Create an instance with [[AMProgressWindowController alloc] init]
		-# Set the initial message with setProgressMessage:
		-# If the user should be able to cancel, call -setUserCanCancel:YES
			and -setUserCanceledBlock:
		-# If the progress bar should be determinate
			-# Call -setIndeterminate:NO
			-# Either periodically call setPercentComplete:, or
			-# Bind a number to the percentComplete binding
		-# Display the window
		-# When through with the window, ssend orderOut: to the window object
		-# release the controller instance
		
	Supported bindings: percentComplete, progressMessage
*/
@interface AMProgressWindowController : NSWindowController<NSWindowDelegate> {
	NSProgressIndicator *progressIndicator;
	NSTextField *statusField;
	NSButton *cancelButton;
	@private
	id _observedObjectForProgValue,_observedObjectForProgMsg;
	NSString *_observedKeyPathForProgValue, *_observedKeyPathForProgMsg;
	AMProgressCancelBlockType _cancelBlock;
}
///Default initializer
-(id)init;

/** Sets the block that will be executed when the user hits the cancel button
	@param block The block to execute */
-(void)setUserCanceledBlock:(AMProgressCancelBlockType)block;

///If determinate, a value from 0 to 100 indicating the percent complete.
@property (assign) CGFloat percentComplete;
///Sets the indterminate value of the progress bar
@property (assign,getter=isIndeterminate) BOOL indeterminate;
///If YES, the cancel button is enabled and the block provided in -setUserCanceledBlock: will be called.
@property (assign) BOOL userCanCancel;
///A string displayed above the progress bar
@property (copy) NSString *progressMessage;
@end
