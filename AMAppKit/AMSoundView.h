//
//  AMSoundView.h
//
//  Created by Mark Lilback on 3/28/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: NA
//

#import <Foundation/Foundation.h>

@protocol AMSoundViewDelegate;

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
@property (nonatomic, assign) IBOutlet id<AMSoundViewDelegate> delegate;
@property (nonatomic, assign) id<NSOpenSavePanelDelegate> panelDelegate;
@property (nonatomic, assign, getter=isEnabled) BOOL enabled;

-(IBAction)selectSoundFile:(id)sender;
-(IBAction)playSound:(id)sender;

-(BOOL)isAIFFFile;
-(BOOL)isWAVFile;
@end

//the delegate is only notified when the file is changed via a user in the open panel, or by drag & drop
@protocol AMSoundViewDelegate <NSObject>
-(void)soundView:(AMSoundView*)soundView userSelectedSound:(NSURL*)soundUrl;
@end