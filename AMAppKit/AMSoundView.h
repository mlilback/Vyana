//
//  AMSoundView.h
//
//  Created by Mark Lilback on 3/28/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: NA
//

#import <Foundation/Foundation.h>

@interface AMSoundView : NSView {
	@private
	NSButton *__bevelButton;
	NSButton *__setButton;
	NSData *__data;
	NSURL *__fileUrl;
}
@property (nonatomic, retain) NSURL *fileURL;
@property (nonatomic, copy)  NSData *soundData;
@property (nonatomic, assign) BOOL canChangeSound;
@property (nonatomic, copy) NSArray *acceptableUTIs;
@property (nonatomic, assign, getter=isEnabled) BOOL enabled;

-(IBAction)selectSoundFile:(id)sender;
-(IBAction)playSound:(id)sender;
@end
