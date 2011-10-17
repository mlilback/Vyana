//
//  AMPreferencesController.m
//
//  Created by Mark Lilback on 8/17/2010.
//  Copyright 2010 Agile Monks, LLC. All rights reserved.
//

#import "AMPreferencesController.h"
#import "AMPreferenceModule.h"
#import "NSArray+AMExtensions.h"

@interface AMPreferencesController ()
-(void)switchToModule:(AMPreferenceModule*)module animate:(BOOL)animate;
-(NSRect)windowFrameForView:(NSView*)view;
-(void)animateViewSwitchFromView:(NSView*)oldView to:(NSView*)newView;
@end

static AMPreferencesController *sInstance=nil;

@implementation AMPreferencesController
@synthesize animateModuleSwitch=_animateSwitch;
+(AMPreferencesController*)defaultInstance
{
	if (nil == sInstance)
		sInstance = [[AMPreferencesController alloc] init];
	return sInstance;
}
-(id)init
{
	NSWindow *win = [[[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 300, 200) 
		styleMask:NSTitledWindowMask | NSClosableWindowMask 
		backing:NSBackingStoreBuffered 
		defer:YES] autorelease];
	if ((self = [super initWithWindow:win])) {
		_modules = [[NSMutableArray alloc] init];
		self.animateModuleSwitch = YES;
		[win setShowsToolbarButton: NO];
		_viewAnimation = [[NSViewAnimation alloc] init];
		[_viewAnimation setAnimationBlockingMode:NSAnimationNonblocking];
		[_viewAnimation setAnimationCurve:NSAnimationEaseInOut];
		[_viewAnimation setDelegate:self];
		[win setExcludedFromWindowsMenu:YES];
	}
	return self;
}
-(void)dealloc
{
	[_viewAnimation release]; _viewAnimation=nil;
	_curModule = nil;
	[_modules release]; _modules=nil;
	[super dealloc];
}

-(BOOL)areModulesLoaded
{
	return [_modules count] > 0;
}

-(void)addModule:(AMPreferenceModule*)module
{
	[_modules addObject: module];
}

-(void)windowWillLoad
{
}

-(void)showWindow:(id)sender
{
	if (nil == [[self window] toolbar]) {
		NSToolbar *tbar = [[NSToolbar alloc] initWithIdentifier:@"PrefsToolbar"];
		[tbar setDisplayMode:NSToolbarDisplayModeIconAndLabel];
		[tbar setAllowsUserCustomization:NO];
		[tbar setAutosavesConfiguration:NO];
		[tbar setDelegate:self];
		[[self window] setToolbar:tbar];
		[tbar release];
		if (nil == _curModule) {
			AMPreferenceModule *mod = [_modules objectAtIndex:0];
			[[[self window] toolbar] setSelectedItemIdentifier:[mod identifier]];
			[self switchToModule:mod animate:NO];
		}
	}
	[[self window] center];
	[super showWindow:sender];

}

-(IBAction)performClose:(id)sender
{
	[self.window performClose:sender];
}

-(NSArray*)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar
{
	return [_modules valueForKey:@"identifier"];
}
-(NSArray*)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar
{
	return [_modules valueForKey:@"identifier"];
}
-(NSToolbarItem*)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier 
	willBeInsertedIntoToolbar:(BOOL)flag
{
	NSToolbarItem *item = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier] autorelease];
	AMPreferenceModule *mod = [_modules firstObjectWithValue:itemIdentifier forKey:@"identifier"];
	if (mod) {
		[item setLabel:[mod title]];
		[item setImage:[mod image]];
		[item setTarget:self];
		[item setAction:@selector(selectModule:)];
	}
	return item;
}

-(void)switchToModule:(AMPreferenceModule*)module animate:(BOOL)animate
{
	NSView *contentView = [[self window] contentView];
	//figure out the old view
	NSView *oldView=nil;
	if ([[contentView subviews] count] > 0) {
		NSEnumerator *en = [[contentView subviews] reverseObjectEnumerator];
		oldView = [en nextObject]; //last view added will count as old view
		//if there were any more views visible (possible if animation is running),
		// remove them
		NSView *otherView=nil;
		while ((otherView = [en nextObject]))
			[otherView removeFromSuperviewWithoutNeedingDisplay];
	}
	if (oldView == [module view])
		return; //same view
	//resize the window
	NSRect frame = [[module view] bounds];
	[[module view] setFrame:frame];
	[contentView addSubview:[module view]];
	[[self window] makeFirstResponder:[module initialFirstResponder]];
	
	if (animate && self.animateModuleSwitch) {
		[self animateViewSwitchFromView:oldView to:[module view]];
	} else {
		[[module view] setHidden:NO];
		[oldView setHidden:YES];
		[[self window] setFrame:[self windowFrameForView:[module view]] display:YES animate:YES];
	}
	[self.window setTitle:[NSString stringWithFormat:@"%@ %@", [module title],
		NSLocalizedString(@"Preferences",@"")]];
	_curModule = module;
}

-(void)animateViewSwitchFromView:(NSView*)oldView to:(NSView*)newView
{
	[_viewAnimation stopAnimation];

	NSDictionary *fadeOutDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
		oldView, NSViewAnimationTargetKey,
		NSViewAnimationFadeOutEffect, NSViewAnimationEffectKey,
		nil];

	NSDictionary *fadeInDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
		newView, NSViewAnimationTargetKey,
		NSViewAnimationFadeInEffect, NSViewAnimationEffectKey,
		nil];

	NSDictionary *resizeDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
		[self window], NSViewAnimationTargetKey,
		[NSValue valueWithRect:[[self window] frame]], NSViewAnimationStartFrameKey,
		[NSValue valueWithRect:[self windowFrameForView:newView]], NSViewAnimationEndFrameKey,
		nil];
	
	NSArray *animationArray = [NSArray arrayWithObjects:
		fadeOutDictionary,
		fadeInDictionary,
		resizeDictionary,
		nil];
	
	[_viewAnimation setViewAnimations:animationArray];
	[_viewAnimation setDuration:0.2];
	[_viewAnimation startAnimation];
}

-(NSRect)windowFrameForView:(NSView*)view
{
	NSRect frame = [self.window frameRectForContentRect:[view frame]];
	frame.origin = [self.window frame].origin;
	frame.origin.y -= frame.size.height - [self.window frame].size.height;
	return frame;
}

-(void)animationDidEnd:(NSAnimation*)animation
{
	NSView *aView=nil;
	//get list of subviews
	NSEnumerator *en = [[[self.window contentView] subviews] reverseObjectEnumerator];
	//this is the current module's view.
	[en nextObject];
	//if the user clicked a lot, there might be other views. remove them all
	while ((aView = [en nextObject]))
		[aView removeFromSuperview];
}

-(void)showModuleWithIdentifier:(NSString*)identifier
{
	AMPreferenceModule *mod = [_modules firstObjectWithValue:identifier forKey:@"identifier"];
	if (mod)
		[self switchToModule:mod animate:YES];
}

-(void)selectModule:(NSToolbarItem*)sender
{
	if (![sender isKindOfClass:[NSToolbarItem class]])
		return;
	[self showModuleWithIdentifier:[sender itemIdentifier]];
}

@end
