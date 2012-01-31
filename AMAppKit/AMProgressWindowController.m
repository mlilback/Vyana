//
//  AMProgressWindowController.m
//
//  Created by Mark Lilback on 8/10/2010.
//  Copyright 2010-11 Agile Monks, LLC. All rights reserved.
//

#import "AMProgressWindowController.h"

#define PERCOMPLETE_BINDNAME @"percentComplete"
#define PERMSG_BINDNAME @"progressMessage"

@interface AMProgressWindowController ()
-(void)cancelButtonPressed:(id)sender;
@end

@implementation AMProgressWindowController
+(void)initialize
{
	[self exposeBinding:PERCOMPLETE_BINDNAME];
	[self exposeBinding:PERMSG_BINDNAME];
}
-(id)init
{
	NSRect winRect = NSRectFromString(@"{{196, 427}, {332, 83}}");
	NSWindow *win = [[[NSWindow alloc] initWithContentRect:winRect 
		styleMask:NSTitledWindowMask|NSClosableWindowMask 
		backing:NSBackingStoreBuffered defer:YES] autorelease];
	if ((self = [super initWithWindow:win])) {
		[win setDelegate:self];
		//set up our interface
		NSView *contentView = [self.window contentView];
		statusField = [[NSTextField alloc] initWithFrame:NSRectFromString(@"{{17, 46}, {298, 17}}")];
		[statusField setEditable:NO];
		[statusField setBordered:NO];
		[statusField setBackgroundColor:[NSColor controlColor]];
		[contentView addSubview:statusField];
		[statusField release];
		progressIndicator = [[NSProgressIndicator alloc] initWithFrame:NSRectFromString(@"{{18, 18}, {204, 20}}")];
		[progressIndicator setIndeterminate:YES];
		[progressIndicator setStyle:NSProgressIndicatorBarStyle];
		[contentView addSubview:progressIndicator];
		[progressIndicator release];
		[progressIndicator startAnimation:self];
		cancelButton = [[NSButton alloc] initWithFrame:NSRectFromString(@"{{222, 12}, {96, 32}}")];
		[cancelButton setTitle:NSLocalizedString(@"Cancel", @"")];
		[cancelButton setBezelStyle:NSRoundedBezelStyle];
		[cancelButton setButtonType:NSMomentaryPushInButton];
		[cancelButton setBordered:YES];
		[cancelButton setAlignment:NSCenterTextAlignment];
		[cancelButton setTarget:self];
		[cancelButton setAction:@selector(cancelButtonPressed:)];
		[cancelButton setEnabled:NO];
		[contentView addSubview:cancelButton];
		[cancelButton release];
	}
	return self;
}

-(void)dealloc
{
	if (_observedObjectForProgValue) {
		[_observedObjectForProgValue removeObserver:self forKeyPath:_observedKeyPathForProgValue];
		_observedObjectForProgValue=nil;
		[_observedKeyPathForProgValue release]; _observedKeyPathForProgValue=nil;
	}
	[super dealloc];
}

//FIXME this is not being called. when the release was in dealloc, we'd get a crash
// we retained the block, but it is no longer valid.
- (void)windowWillClose:(NSNotification *)notification
{
	//[_cancelBlock release]; 
	_cancelBlock=nil;
}

-(void)bind:(NSString *)binding toObject:(id)observable 
	withKeyPath:(NSString *)keyPath options:(NSDictionary *)options
{
	if ([binding isEqualToString:PERCOMPLETE_BINDNAME]) {
		_observedObjectForProgValue = observable;
		_observedKeyPathForProgValue = [keyPath copy];
		[_observedObjectForProgValue addObserver:self
			forKeyPath:_observedKeyPathForProgValue options:0 context:nil];
	} else if ([binding isEqualToString:PERMSG_BINDNAME]) {
		_observedObjectForProgMsg = observable;
		_observedKeyPathForProgMsg = [keyPath copy];
		[_observedObjectForProgMsg addObserver:self
			forKeyPath:_observedKeyPathForProgMsg options:0 context:nil];
	}
}

-(void)unbind:(NSString *)binding
{
	if ([binding isEqualToString:PERCOMPLETE_BINDNAME]) {
		[_observedObjectForProgValue removeObserver:self 
			forKeyPath:_observedKeyPathForProgValue];
		_observedObjectForProgValue = nil;
		[_observedKeyPathForProgValue release];
		_observedKeyPathForProgValue = nil;
	} else  if ([binding isEqualToString:PERMSG_BINDNAME]) {
		[_observedObjectForProgMsg removeObserver:self 
			forKeyPath:_observedKeyPathForProgMsg];
		_observedObjectForProgMsg = nil;
		[_observedKeyPathForProgMsg release];
		_observedKeyPathForProgMsg = nil;
	}
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object 
	change:(NSDictionary *)change context:(void *)contex
{
	if ([keyPath isEqualToString:_observedKeyPathForProgValue] && object == _observedObjectForProgValue) 
	{
		[self setPercentComplete:
			[[_observedObjectForProgValue valueForKey:_observedKeyPathForProgValue] floatValue]];
	} else if ([keyPath isEqualToString:_observedKeyPathForProgMsg] && object == _observedObjectForProgMsg) {
		[self setProgressMessage:[_observedObjectForProgMsg valueForKey:_observedKeyPathForProgMsg]];
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:contex];
	}
}

-(BOOL)userCanCancel { return [cancelButton isEnabled]; }
-(void)setUserCanCancel:(BOOL)flag { [cancelButton setEnabled:flag]; }
-(NSString*)progressMessage { return [statusField stringValue]; }
-(void)setProgressMessage:(NSString *)str { [statusField setStringValue:str]; }
-(BOOL)isIndeterminate { return [progressIndicator isIndeterminate]; }
-(void)setIndeterminate:(BOOL)flag
{
	[progressIndicator setIndeterminate:flag];
	[progressIndicator startAnimation:self];
}
-(CGFloat)percentComplete { return [progressIndicator doubleValue]; }
-(void)setPercentComplete:(CGFloat)val
{
	if (val < 0)
		val = 0;
	else if (val > 100.0)
		val = 100;
	[progressIndicator setDoubleValue:val];
}

-(void)setUserCanceledBlock:(AMProgressCancelBlockType)block
{
	_cancelBlock = [block retain];
}

-(void)windowDidExpose:(NSNotification*)note
{
	if ([progressIndicator isIndeterminate])
		[progressIndicator startAnimation:self];
	else
		[progressIndicator setDoubleValue:0.0];
}

-(void)cancelButtonPressed:(id)sender
{
	if (_cancelBlock)
		_cancelBlock(self);
}
@end
