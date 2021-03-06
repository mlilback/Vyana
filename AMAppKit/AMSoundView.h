//
//  AMSoundView.h
//
//  Created by Mark Lilback on 3/28/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: NA
//

#import <Cocoa/Cocoa.h>
#import <AudioToolbox/AudioToolbox.h>

/** exposes binding "enabled". This does not work like NSControl's version that allows
 	multiple bindings that are AND'd together. Only one property can be bound. */

@protocol AMSoundViewDelegate;

@interface AMSoundView : NSView {
	@private
	NSButton *__bevelButton;
	NSButton *__setButton;
	NSButton *__deleteButton;
	BOOL __drawFocusRing;
}
@property (nonatomic, retain) NSURL *fileURL;
@property (nonatomic, copy)  NSData *soundData;
@property (nonatomic, assign) BOOL canChangeSound;
@property (nonatomic, copy) NSArray *acceptableUTIs;
@property (nonatomic, assign) IBOutlet id<AMSoundViewDelegate> delegate;
@property (nonatomic, assign) id<NSOpenSavePanelDelegate> panelDelegate;
@property (nonatomic, assign, getter=isEnabled) BOOL enabled;

-(IBAction)selectSoundFile:(id)sender;
-(IBAction)playSound:(id)sender;
-(IBAction)deleteSound:(id)sender;

-(BOOL)isAIFFFile;
-(BOOL)isWAVFile;
-(BOOL)isCafFile;

-(BOOL)saveSoundDataAsCAFF:(NSURL*)destUrl;
-(NSData*)soundDataAsCAFF;
@end

//the delegate is only notified when the file is changed via a user in the open panel, or by drag & drop
@protocol AMSoundViewDelegate <NSObject>
-(void)soundView:(AMSoundView*)soundView userSelectedSound:(NSURL*)soundUrl;
@end