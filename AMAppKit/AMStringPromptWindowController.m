//
//  AMStringPromptWindowController.m
//  Vyana
//
//  Created by Mark Lilback on 1/19/12.
//  Copyright 2012 Agile Monks. All rights reserved.
//

#import "AMBlockUtils.h"
#import "NSFont+AMExtensions.h"
#import "AMStringPromptWindowController.h"
#import "NSTextField+AMExtensions.h"

@interface AMStringPromptWindowController()
@property (nonatomic, copy) BasicBlock1IntArg handler;
@end

@implementation AMStringPromptWindowController
-(id)init
{
	self = [super initWithWindowNibName:@"AMStringPromptWindowController"];
	self.promptString = @"Name:";
	self.okButtonTitle = @"OK";
	self.stringValue = @"";
	return self;
}

-(void)windowDidLoad
{
	[self.validationMessageLabel setFont:[self.validationMessageLabel.font italicVersion]];
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
{
	[self.window orderOut:self];
	self.handler(returnCode);
}

-(void)displayModelForWindow:(NSWindow*)parentWindow completionHandler:(BasicBlock1IntArg)block
{
	self.handler = block;
	[self window];
	[NSApp beginSheet:self.window 
	   modalForWindow:parentWindow 
		modalDelegate:self 
	   didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) 
		  contextInfo:nil];
}

-(IBAction)ok:(id)sender
{
	[NSApp endSheet:self.window returnCode:NSOKButton];
}

-(IBAction)cancel:(id)sender
{
	[NSApp endSheet:self.window returnCode:NSCancelButton];
}

-(void)setupValidationLabel
{
}

-(BOOL)stringAcceptable
{
	BOOL validated = YES;
	if (self.validationBlock) {
		if (self.stringValue.length > 0)
			validated = self.validationBlock(self);
		//now we need to show/hide the validation message
		if (validated) {
			[self.validationMessageLabel setHidden:YES];
		} else {
			if (nil == self.validationMessageLabel)
				[self setupValidationLabel];
			self.validationMessageLabel.stringValue = self.validationErrorMessage;
			[self.validationMessageLabel setHidden:NO];
			[self.validationMessageLabel resizeFontToFitText:7.0 maxSize:13.0];
		}
	}
	if (!validated)
		return NO;
	return self.stringValue.length > 0;
}

- (void)controlTextDidChange:(NSNotification *)aNotification
{
	[self willChangeValueForKey:@"stringAcceptable"];
	[self didChangeValueForKey:@"stringAcceptable"];
}

@synthesize stringValue;
@synthesize promptString;
@synthesize okButtonTitle;
@synthesize handler;
@synthesize validationBlock;
@synthesize validationErrorMessage;
@synthesize validationMessageLabel;
@synthesize stringField;
@end
