//
//  AMPreferenceModule.h
//
//  Created by Mark Lilback on 8/17/2010.
//  Copyright 2010 Agile Monks, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AMPreferenceModule : NSViewController {
	@private
	NSImage *_image;
	NSString *_identifier;
	NSResponder *_initialFirstResponder;
}
+(AMPreferenceModule*)moduleWithNibName:(NSString*)nibName bundle:(NSBundle*)bundle
	title:(NSString*)title identifier:(NSString*)ident imageName:(NSString*)imageName;

///by default returns the General preferences image
@property (retain) NSImage *image;
///identifier used fofr NSToolbar calls
@property (copy) NSString *identifier;
///is make the first responder when the view is loaded
@property (assign) IBOutlet NSResponder *initialFirstResponder;
@end
