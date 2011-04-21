//
//  AMPreferenceModule.m
//
//  Created by Mark Lilback on 8/17/2010.
//  Copyright 2010 Agile Monks, LLC. All rights reserved.
//

#import "AMPreferenceModule.h"


@implementation AMPreferenceModule
@synthesize initialFirstResponder=_initialFirstResponder,image=_image,
	identifier=_identifier;

+(AMPreferenceModule*)moduleWithNibName:(NSString*)nibName bundle:(NSBundle*)bundle
	title:(NSString*)title identifier:(NSString*)ident imageName:(NSString*)imageName
{
	AMPreferenceModule *module = [[[self alloc] initWithNibName:nibName bundle:bundle] autorelease];
	module.title = title;
	module.identifier = ident;
	if (imageName) {
		NSImage *img = [NSImage imageNamed:imageName];
		if (nil == img) {
			if (nil == bundle)
				bundle = [NSBundle mainBundle];
			NSURL *imgUrl = [bundle URLForResource:imageName withExtension:nil];
			if (imgUrl) {
				img = [[[NSImage alloc] initWithContentsOfURL:imgUrl] autorelease];
			}
		} else {
			module.image = [NSImage imageNamed:imageName];
		}
		module.image = img;
	}
	return module;
}

-(id)initWithNibName:(NSString*)nibName bundle:(NSBundle*)bundle
{
	if ((self = [super initWithNibName:nibName bundle:bundle])) {
		self.title = @"lazy programmer";
		self.identifier = @"com.fart.clownpenis";
		self.initialFirstResponder = self;
		self.image = [NSImage imageNamed:NSImageNamePreferencesGeneral];
	}
	return self;
}
-(void)dealloc
{
	self.title=nil;
	self.image=nil;
	self.identifier=nil;
	[super dealloc];
}
@end
