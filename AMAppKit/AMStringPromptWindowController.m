//
//  AMStringPromptWindowController.m
//  Vyana
//
//  Created by Mark Lilback on 1/19/12.
//  Copyright 2012 Agile Monks. All rights reserved.
//

#import "AMBlockUtils.h"
#import "AMStringPromptWindowController.h"

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
	NSRect r = self.window.frame;
	r.size.height += 20;
	[self.window setFrame:r display:YES animate:YES];
//	[NSApp endSheet:self.window returnCode:NSCancelButton];
}

-(BOOL)stringAcceptable
{
	if (self.validationBlock && !self.validationBlock(self.stringValue))
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
@end
