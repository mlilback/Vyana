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
#import "NSFileHandle+AMExtensions.h"
#import "NSString+AMExtensions.h"
#import <AudioToolbox/AudioToolbox.h>

#define ENABLED_BINDNAME @"enabled"
#define DRAG_FILE_TYPES [NSArray arrayWithObjects:NSFilenamesPboardType,NSURLPboardType,nil]

@interface AMSoundView()
-(void)setupSubviews;
-(void)adjustFileImage;
@property SystemSoundID soundID;
@property (nonatomic, retain) NSImage *noSoundImage;
@property (nonatomic, assign) id observedObjectForEnabled;
@property (nonatomic, copy) NSString *observedKeyPathForEnabled;
@property (assign) BOOL shouldDrawFocusRing;
@end

@implementation AMSoundView
+(void)initialize
{
	[self exposeBinding:ENABLED_BINDNAME];
}

//our frame must be 48x70 or 96x48
- (id)initWithFrame:(NSRect)frame
{
	if (frame.size.width > frame.size.height)
		frame.size = NSMakeSize(96, 48);
	else
		frame.size = NSMakeSize(48, 70);
	if ((self = [super initWithFrame:frame])) {
		[self setupSubviews];
		[self registerForDraggedTypes:DRAG_FILE_TYPES];
	}
	return self;
}

- (void)dealloc
{
	if (self.observedObjectForEnabled) {
		[self.observedObjectForEnabled removeObserver:self forKeyPath:self.observedKeyPathForEnabled];
		self.observedObjectForEnabled=nil;
		self.observedKeyPathForEnabled=nil;
	}
	self.noSoundImage = nil;
	[__bevelButton release];
	[__setButton release];
	[__deleteButton release];
	[super dealloc];
}

-(void)awakeFromNib
{
	[self registerForDraggedTypes:DRAG_FILE_TYPES];
	if (nil == __bevelButton)
		[self setupSubviews];
}

-(void)setupSubviews
{
	NSRect bevelFrame = NSMakeRect(0, 22, 48, 48);
	NSRect setFrame = NSMakeRect(1, 2, 46, 16);
	NSRect delFrame = NSZeroRect;
	if (self.frame.size.width > self.frame.size.height) {
		bevelFrame = NSMakeRect(0, 0, 48, 48);
		setFrame = NSMakeRect(52, 30, 46, 16);
		delFrame = NSMakeRect(61, 2, 28, 28);
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
	id theCell = [__setButton cell];
	[theCell setControlSize:NSMiniControlSize];
	CGFloat fntSize = [NSFont systemFontSizeForControlSize:NSMiniControlSize];
	[[__setButton cell] setFont:[NSFont systemFontOfSize:fntSize]];
	[__setButton setTitle:@"set"];
	[__setButton setTarget:self];
	[__setButton setAction:@selector(selectSoundFile:)];

	if (delFrame.size.width > 0) {
		__deleteButton = [[NSButton alloc] initWithFrame:delFrame];
		[self addSubview:__deleteButton];
		[__deleteButton setBezelStyle:NSRegularSquareBezelStyle];
		[__deleteButton setButtonType:NSMomentaryPushInButton];
		[__deleteButton setTarget: self];
		[__deleteButton setAction:@selector(deleteSound:)];
		NSURL *delUrl =  [[NSBundle bundleForClass:[self class]] URLForResource:@"VyanaDelete" withExtension:@"icns"];
		NSImage *delImg = [[NSImage alloc] initByReferencingURL:delUrl];
		[delImg setSize:NSMakeSize(16, 16)];
		[__deleteButton setImage:delImg];
		[delImg release];
	}
	
	NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:@"nosound" withExtension:@"icns"];
	NSImage *img = [[NSImage alloc] initByReferencingURL:url];
	[img setSize:NSMakeSize(32, 32)];
	self.noSoundImage = img;
	[img release];
	[self adjustFileImage];
}

-(void)adjustFileImage
{
	if (nil == self.soundData) {
		[__bevelButton setImage:self.noSoundImage];
		[__bevelButton setEnabled:NO];
		[__deleteButton setEnabled:NO];
		return;
	}
	[__bevelButton setEnabled:YES];
	NSString *ftype = @"aif";
	if ([self isWAVFile])
		ftype = @"wav";
	else if ([self isCafFile])
		ftype = @"caf";
	NSImage *img = [[NSWorkspace sharedWorkspace] iconForFileType:ftype];
	[__bevelButton setImage:img];
}

#pragma mark - bindings

-(void)bind:(NSString *)binding 
   toObject:(id)observable 
withKeyPath:(NSString *)keyPath 
	options:(NSDictionary *)options
{
	if ([binding isEqualToString:ENABLED_BINDNAME]) {
		self.observedObjectForEnabled = observable;
		self.observedKeyPathForEnabled = keyPath;
		[self.observedObjectForEnabled addObserver:self 
										forKeyPath:self.observedKeyPathForEnabled 
										   options:0 
										   context:nil];
	}
}

-(void)unbind:(NSString *)binding
{
	if ([binding isEqualToString:ENABLED_BINDNAME]) {
		[self.observedObjectForEnabled removeObserver:self 
										 forKeyPath:self.observedKeyPathForEnabled];
		self.observedObjectForEnabled = nil;
		self.observedKeyPathForEnabled = nil;
	}
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object 
					   change:(NSDictionary *)change context:(void *)contex
{
	if ([keyPath isEqualToString:self.observedKeyPathForEnabled] && object == self.observedObjectForEnabled) 
	{
		BOOL shouldEnable = [[self.observedObjectForEnabled valueForKey:self.observedKeyPathForEnabled] boolValue];
		[self setEnabled:shouldEnable];
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:contex];
	}
}

#pragma mark - drag & drop

-(BOOL)pasteboardHasAcceptableFile:(NSPasteboard*)pboard
{
	static NSArray *acceptableFileTypes=nil;
	static dispatch_once_t pred;
	
	dispatch_once(&pred, ^{ acceptableFileTypes = [[NSArray alloc] initWithObjects:@"wav",@"aif",@"caf",nil]; });
	
	
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
							 [NSNumber numberWithBool:YES], NSPasteboardURLReadingFileURLsOnlyKey, nil];
	if ([pboard canReadObjectForClasses:[NSArray arrayWithObject:[NSURL class]] options:options]) {
		//FIXME -- this code is buggy
		NSArray *objects = [pboard readObjectsForClasses:[NSArray arrayWithObject:[NSURL class]] options:nil];
		NSURL *aUrl = [objects objectAtIndex:0];
		//it is a file and files are acceptable. check the acceptable file types
		return ([acceptableFileTypes containsObject:[aUrl pathExtension]]);
	}
	return NO;
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
	if (!self.isEnabled || ![self pasteboardHasAcceptableFile:[sender draggingPasteboard]])
		return NSDragOperationNone;
	self.shouldDrawFocusRing = YES;
	return NSDragOperationLink;
}

-(void)draggingExited:(id <NSDraggingInfo>)sender
{
	self.shouldDrawFocusRing = NO;
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender
{
	if (!self.isEnabled || ![self pasteboardHasAcceptableFile:[sender draggingPasteboard]])
		return NSDragOperationNone;
	return NSDragOperationLink;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
	self.shouldDrawFocusRing = NO;
	if (!self.isEnabled || ![self pasteboardHasAcceptableFile:[sender draggingPasteboard]])
		return NO;
	NSPasteboard *pboard = [sender draggingPasteboard];
	NSArray *objects = [pboard readObjectsForClasses:[NSArray arrayWithObject:[NSURL class]] options:nil];
	if (!IsEmpty(objects)) {
		self.fileURL = [objects objectAtIndex:0];
		[self.delegate soundView:self userSelectedSound:self.fileURL];
		return YES;
	}
	return NO;
}

#pragma mark - standard

-(void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	if (__drawFocusRing) {
		NSSetFocusRingStyle(NSFocusRingOnly);
		NSRectFill(self.bounds);
	}
}

#pragma mark - actions
-(IBAction)selectSoundFile:(id)sender
{
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	NSArray *ftypes = self.acceptableUTIs;
	if ([ftypes count] < 1)
		ftypes = [NSSound soundUnfilteredTypes];
	[openPanel setAllowedFileTypes:ftypes];
	[openPanel setDelegate: self.panelDelegate];
	[openPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger results) {
		if (NSFileHandlingPanelOKButton == results) {
			NSURL *selUrl = [[openPanel URLs] firstObject];
			self.fileURL = selUrl;
			[self.delegate soundView:self userSelectedSound:selUrl];
		}
	}];
}

-(IBAction)playSound:(id)sender
{
	if (self.soundID == 0) {
		if (_fileURL)
		AudioServicesCreateSystemSoundID((__bridge CFURLRef)_fileURL, &_soundID);
	}
	AudioServicesPlaySystemSound(self.soundID);
}

-(IBAction)deleteSound:(id)sender
{
	self.soundData=nil;
	[self.delegate soundView:self userSelectedSound:nil];
}

#pragma mark - meat & potatoes

-(BOOL)isAIFFFile
{
	char buff[5];
	bzero(buff, 5);
	[self.soundData getBytes:buff length:5];
	return buff[0] == 0x46 && buff[1] == 0x4F && buff[2] == 0x52 && buff[3] == 0x4D &&
		buff[4] == 0x00;
}

-(BOOL)isWAVFile
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

-(BOOL)isCafFile
{
	if(nil == self.soundData)
		return NO;
	CAFFileHeader head;
	bzero(&head, sizeof(head));
	[self.soundData getBytes:&head length:sizeof(head)];
	return (head.mFileType == 'caff') && (head.mFileVersion == 1) && (head.mFileFlags == 0);
}

-(NSData*)soundDataAsCAFF
{
	if ([self isCafFile])
		return self.soundData;
	NSData *data=nil;
	//figure out a tmp location to store at it
	NSString *tmpFileName = [NSString stringWithUUID];
	NSURL *tmpUrl = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:tmpFileName];
	if ([self saveSoundDataAsCAFF:tmpUrl]) {
		data = [NSData dataWithContentsOfURL:tmpUrl];
		[[NSFileManager defaultManager] removeItemAtURL:tmpUrl error:nil];
	}
	return data;
}

-(BOOL)saveSoundDataAsCAFF:(NSURL*)destUrl
{
	if (nil == self.soundData)
		return NO;
	NSString *tmpPath=nil;
	NSFileHandle *tmpFH = [NSFileHandle fileHandleForWritingTemporaryFileWithPrefix:@"amsnd"
																			filePath:&tmpPath];
	if (nil == tmpFH)
		return NO;
	[tmpFH writeData:self.soundData];
	[tmpFH closeFile];
	NSTask *convertTask = [[[NSTask alloc] init] autorelease];
	[convertTask setLaunchPath:@"/usr/bin/afconvert"];
	[convertTask setArguments:[NSArray arrayWithObjects:@"-f", @"caff", @"-d", @"LEI16", tmpPath, [destUrl path], nil]];
	[convertTask launch];
	[convertTask waitUntilExit];
	[[NSFileManager defaultManager] removeItemAtPath:tmpPath error:nil];
	return [convertTask terminationStatus] == 0;
}

#pragma mark- accessors

-(BOOL)shouldDrawFocusRing
{
	return __drawFocusRing;
}
-(void)setShouldDrawFocusRing:(BOOL)val
{
	__drawFocusRing = val;
	[self setNeedsDisplay:YES];
	[[self superview] setNeedsDisplayInRect:NSInsetRect([self frame], -4, -4)];
}

-(void)setSoundData:(NSData *)soundData
{
	NSString *tmpPath=nil;
	NSFileHandle *tmpFH = [NSFileHandle fileHandleForWritingTemporaryFileWithPrefix:@"amsnd"
																		   filePath:&tmpPath];
	[tmpFH writeData:self.soundData];
	[tmpFH closeFile];

	self.fileURL = [NSURL fileURLWithPath:tmpPath];
}

-(void)setFileURL:(NSURL *)fileURL
{
	if ([_fileURL isEqual:fileURL])
		return;
	[_fileURL release];
	if (self.soundID != 0) {
		AudioServicesDisposeSystemSoundID(self.soundID);
		self.soundID = 0;
	}
	_fileURL = [fileURL retain];
	[self willChangeValueForKey:@"soundData"];
	[_soundData release];
	_soundData = [[NSData alloc] initWithContentsOfURL:fileURL];
	[self didChangeValueForKey:@"soundData"];
	[self adjustFileImage];
}

-(BOOL)isEnabled
{
	return [__setButton isEnabled];
}
-(void)setEnabled:(BOOL)enabled
{
	[__bevelButton setEnabled:enabled && nil != self.soundData];
	[__setButton setEnabled:enabled];
	[__deleteButton setEnabled:[__bevelButton isEnabled]];
}

@synthesize shouldDrawFocusRing=__drawFocusRing;
@end
