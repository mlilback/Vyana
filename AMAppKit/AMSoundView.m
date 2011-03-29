//
//  AMSoundView.m
//
//  Created by Mark Lilback on 3/28/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: NA
//

#import "AMSoundView.h"
#import "NSArray+AMExtensions.h"

@interface AMSoundView()
-(BOOL)isAifFile;
-(BOOL)isWavFile;
-(void)setupSubviews;
-(void)adjustFileImage;
@property (nonatomic, retain) NSSound *currentSound;
@end

@implementation AMSoundView

//our frame must be 48x70 or 96x48
- (id)initWithFrame:(NSRect)frame
{
	if (frame.size.width > frame.size.height)
		frame.size = NSMakeSize(96, 48);
	else
		frame.size = NSMakeSize(48, 70);
	if ((self = [super initWithFrame:frame])) {
		[self setupSubviews];
	}
	return self;
}

- (void)dealloc
{
	self.currentSound=nil;
	[__bevelButton release];
	[__setButton release];
	[super dealloc];
}

-(void)awakeFromNib
{
	if (nil == __bevelButton)
		[self setupSubviews];
}

-(void)setupSubviews
{
	NSRect bevelFrame = NSMakeRect(0, 22, 48, 48);
	NSRect setFrame = NSMakeRect(1, 2, 46, 16);
	if (self.frame.size.width > self.frame.size.height) {
		bevelFrame = NSMakeRect(0, 0, 48, 48);
		setFrame = NSMakeRect(49, 16, 46, 16);
	}
	__bevelButton = [[NSButton alloc] initWithFrame:bevelFrame];
	[self addSubview:__bevelButton];
	[__bevelButton setBezelStyle:NSRegularSquareBezelStyle];
	[__bevelButton setButtonType:NSMomentaryPushInButton];
	[__bevelButton setTarget: self];
	[__bevelButton setAction:@selector(playSound:)];

	__setButton = [[NSButton alloc] initWithFrame:setFrame];
	[self addSubview:__setButton];
	[__setButton setBezelStyle:NSRegularSquareBezelStyle];
	[__setButton setButtonType:NSMomentaryPushInButton];
	[__setButton setTitle:@"set"];
	[__setButton setTarget:self];
	[__setButton setAction:@selector(selectSoundFile:)];
	[self adjustFileImage];
}

-(void)adjustFileImage
{
	NSString *ftype = @"aif";
	if ([self isWavFile])
		ftype = @"wav";
	NSImage *img = [[NSWorkspace sharedWorkspace] iconForFileType:ftype];
	if (nil == img)
		img = [[NSWorkspace sharedWorkspace] iconForFileType:@"wav"];
	[__bevelButton setImage:img];
}

#pragma mark - actions
-(IBAction)selectSoundFile:(id)sender
{
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	NSArray *ftypes = self.acceptableUTIs;
	if ([ftypes count] < 1)
		ftypes = [NSSound soundUnfilteredTypes];
	[openPanel setAllowedFileTypes:ftypes];
	[openPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger results) {
		if (NSFileHandlingPanelOKButton == results) {
			NSURL *selUrl = [[openPanel URLs] firstObject];
			self.fileURL = selUrl;
		}
	}];
}

-(IBAction)playSound:(id)sender
{
	if (nil == self.currentSound) {
		NSSound *snd = [[NSSound alloc] initWithData:self.soundData];
		self.currentSound = snd;
		[snd release];
	}
	[self.currentSound play];
}

#pragma mark - meat & potatoes

-(BOOL)isAifFile
{
	char buff[5];
	bzero(buff, 5);
	[self.soundData getBytes:buff length:5];
	return buff[0] == 0x46 && buff[1] == 0x4F && buff[2] == 0x52 && buff[3] == 0x4D &&
		buff[4] == 0x00;
}

-(BOOL)isWavFile
{
	if(nil == self.soundData)
		return NO;
	char buff[16];
	bzero(buff, 16);
	[self.soundData getBytes:buff length:16];
	return buff[0] == 0x52 && buff[1] == 0x49 && buff[2] == 0x46 && buff[3] == 0x46 &&
		buff[8] == 0x57 && buff[9] == 0x41 && buff[10] == 0x56 && buff[11] == 0x45 && 
		buff[12] == 0x66 && buff[13] == 0x6D&& buff[14] == 0x74 && buff[15] == 0x20;
}

#pragma mark- accessors

-(NSData*)soundData { return __data; }

-(void)setSoundData:(NSData *)soundData
{
	if ([__data isEqualToData:soundData])
		return;
	[__data release];
	__data = [soundData copy];
	[self willChangeValueForKey:@"fileURL"];
	[__fileUrl release];
	__fileUrl = nil;
	[self didChangeValueForKey:@"fileURL"];
	[self adjustFileImage];
	self.currentSound=nil;
}

-(NSURL*)fileURL { return __fileUrl; }

-(void)setFileURL:(NSURL *)fileURL
{
	if ([__fileUrl isEqual:fileURL])
		return;
	[__fileUrl release];
	__fileUrl = [fileURL retain];
	[self willChangeValueForKey:@"soundData"];
	[__data release];
	__data = [[NSData alloc] initWithContentsOfURL:fileURL];
	[self didChangeValueForKey:@"soundData"];
	[self adjustFileImage];
	self.currentSound=nil;
}

-(BOOL)isEnabled
{
	return [__bevelButton isEnabled];
}
-(void)setEnabled:(BOOL)enabled
{
	[__bevelButton setEnabled:enabled];
	[__setButton setEnabled:enabled];
}

@synthesize currentSound;
@synthesize canChangeSound;
@synthesize acceptableUTIs;
@end
