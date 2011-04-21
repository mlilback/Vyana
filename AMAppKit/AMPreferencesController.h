//
//  AMPreferencesController.h
//
//  Created by Mark Lilback on 8/17/2010.
//  Copyright 2010 Agile Monks, LLC. All rights reserved.
//
//  Ideas and design patterns taken from code by Matt Ball and James Huddleston
//

#import <Cocoa/Cocoa.h>

@class AMPreferenceModule;

/**
	All modules should be added before showWindow: or loadWindow is called.
	
	The easy implementation just requires writing nibs using bindings and then adding the following
	to app delegate.
	
	-(IBAction)showPreferences:(id)sender
	{
		AMPreferencesController *prefsController = [AMPreferencesController defaultInstance];
		if (![prefsController areModulesLoaded]) {
			//need to load our prefs modules
			[prefsController addModule:[AMPreferenceModule moduleWithNibName: @"GeneralPrefs"
				bundle: nil title: @"General" identifier:@"general" imageName:nil]];
			[prefsController addModule:[AMPreferenceModule moduleWithNibName: @"ScriptPrefs"
				bundle: nil title: @"Scripts" identifier:@"scripting" imageName:nil]];
		}
		[prefsController showWindow:sender];
	}
*/
@interface AMPreferencesController : NSWindowController<NSToolbarDelegate,NSAnimationDelegate> {
	@private
	NSMutableArray *_modules;
	AMPreferenceModule *_curModule;
	NSViewAnimation *_viewAnimation;
	BOOL _animateSwitch;
}
+(AMPreferencesController*)defaultInstance;

@property (assign) BOOL animateModuleSwitch;
@property (readonly) BOOL areModulesLoaded;

-(void)addModule:(AMPreferenceModule*)module;
-(void)selectModule:(NSToolbarItem*)sender;
-(void)showModuleWithIdentifier:(NSString*)identifier;
@end
