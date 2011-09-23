//
//  AMFileSelectionView.m
//
//  Created by Mark Lilback on 10/16/10.
//  Copyright 2010-11 Agile Monks, LLC. All rights reserved.
//

#import "AMFileSelectionView.h"

@interface AMFileSelectionView() {
	id _privData;
	NSURL *__theFile;
	BOOL __drawFocusRing;
}
-(BOOL)pasteboardHasAcceptableFile:(NSPasteboard*)pboard;
-(void)initSmall;
-(void)initLarge;
-(void)commonInit;
@property (assign) BOOL shouldDrawFocusRing;
@end

@implementation AMFileSelectionView
-(id)initWithFrame:(NSRect)frameRect
{
	ZAssert(frameRect.size.width>= 140 && frameRect.size.height >= 30, 
		@"AMFileSelectionView must be at least 250 x 30 in size");
	if ((self = [super initWithFrame:frameRect])) {
		_privData = [[NSMutableDictionary alloc] init];
		if (frameRect.size.height >= 48)
			[self initLarge];
		else
			[self initSmall];
		[self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType,NSURLPboardType,nil]];
		[self setTitlePosition:NSNoTitle];
		self.filesAreAcceptable = YES;
	}
	return self;
}

-(void)dealloc
{
	self.theFile=nil;
	self.acceptableFileTypes=nil;
	[_privData release];_privData=nil;
	[super dealloc];
}

-(IBAction)promptForFile:(id)sender
{
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	[openPanel setCanChooseFiles:self.filesAreAcceptable];
	[openPanel setCanChooseDirectories:self.foldersAreAcceptable];
	[openPanel setShowsHiddenFiles:self.showsHiddenFiles];
	[openPanel setAllowedFileTypes:self.acceptableFileTypes];
	[openPanel setTreatsFilePackagesAsDirectories:self.showsPackageContents];
	if (self.theFile)
		[openPanel setDirectoryURL:self.theFile];
	[openPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger results) {
			if (NSFileHandlingPanelOKButton == results) {
				self.theFile = [[openPanel URLs] objectAtIndex:0];
			}
		}];
}

-(void)setTheFile:(NSURL*)fileUrl
{
	if (fileUrl == __theFile)
		return;
	[__theFile release];
	__theFile = [fileUrl retain];
	[[_privData objectForKey:@"imgView"] 
		setImage:[[NSWorkspace sharedWorkspace] iconForFile:[fileUrl path]]];
	[[_privData objectForKey:@"textField"] 
		setStringValue:[[NSFileManager defaultManager] displayNameAtPath:[fileUrl path]]];
	[self setToolTip:[fileUrl path]];
}

-(void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	if (__drawFocusRing) {
		NSSetFocusRingStyle(NSFocusRingOnly);
		NSRectFill(self.bounds);
	}
}

-(BOOL)pasteboardHasAcceptableFile:(NSPasteboard*)pboard
{
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithBool:YES], NSPasteboardURLReadingFileURLsOnlyKey, nil];
	if ([pboard canReadObjectForClasses:[NSArray arrayWithObject:[NSURL class]] options:options]) {
		//FIXME -- this code is buggy
		NSArray *objects = [pboard readObjectsForClasses:[NSArray arrayWithObject:[NSURL class]] options:nil];
		NSURL *aUrl = [objects objectAtIndex:0];
		id propVal=nil;
		if ([aUrl getResourceValue:&propVal forKey:NSURLIsDirectoryKey error:nil]) {
			//w know if it is a directory
			if ([propVal boolValue] && !self.foldersAreAcceptable)
				return NO;
			if (![propVal boolValue] && !self.filesAreAcceptable)
				return NO;
			if ([propVal boolValue])
				return YES;
		}
		if ([aUrl getResourceValue:&propVal forKey:NSURLIsRegularFileKey error:nil]) {
			if ([propVal boolValue] && !self.filesAreAcceptable)
				return NO;
			if (![propVal boolValue])
				return NO;
			//it is a file and files are acceptable. check the acceptable file types
			if (self.acceptableFileTypes && 
				![self.acceptableFileTypes containsObject:[aUrl pathExtension]])
			{
				return NO;
			}
		}
		return YES;
	}
	return NO;
}

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

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
	if (![self pasteboardHasAcceptableFile:[sender draggingPasteboard]])
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
	if (![self pasteboardHasAcceptableFile:[sender draggingPasteboard]])
		return NSDragOperationNone;
	return NSDragOperationLink;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
	self.shouldDrawFocusRing = NO;
	if (![self pasteboardHasAcceptableFile:[sender draggingPasteboard]])
		return NO;
	NSPasteboard *pboard = [sender draggingPasteboard];
	NSArray *objects = [pboard readObjectsForClasses:[NSArray arrayWithObject:[NSURL class]] options:nil];
	if (!IsEmpty(objects)) {
		self.theFile = [objects objectAtIndex:0];
		return YES;
	}
	return NO;
}

-(void)initSmall
{
	NSRect frameRect = self.frame;
	CGFloat dimen = frameRect.size.height - 8;
	if (frameRect.size.height < 31)
		dimen--;
	NSImageView *imgView = [[NSImageView alloc] initWithFrame:NSMakeRect(4, 4, dimen, dimen)];
	[self addSubview:imgView];
	[_privData setObject:imgView forKey:@"imgView"];
	[imgView release];

	NSButton *button = [[NSButton alloc] initWithFrame:
		NSMakeRect(frameRect.size.width-88, frameRect.size.height-25, 84, 20)];
	[self addSubview:button];
	[_privData setObject:button forKey:@"button"];
	[button release];

	dimen = floor(frameRect.size.height -17);
	NSTextField *txtField = [[NSTextField alloc] initWithFrame:
		NSMakeRect(NSMaxX(imgView.frame)+6, dimen, button.frame.origin.x - 8, 17)];
	[self addSubview:txtField];
	[_privData setObject:txtField forKey:@"textField"];
	[txtField release];

	[self commonInit];
}

-(void)initLarge
{
	//give us a 2 pixel border if there is enough space in our frame
	CGFloat offset = 0;
	if (NSContainsRect(self.frame, NSInsetRect(self.frame, -2, -2)))
		offset = 2;
	NSImageView *imgView = [[NSImageView alloc] initWithFrame:NSMakeRect(offset, offset, 46, 46)];
	[imgView setImageFrameStyle:NSImageFrameNone];
	[self addSubview:imgView];
	[_privData setObject:imgView forKey:@"imgView"];
	[imgView release];

	NSButton *button = [[NSButton alloc] initWithFrame:
		NSMakeRect(NSMaxX(imgView.frame)+4, offset+2, 50, 16)];
	[self addSubview:button];
	[_privData setObject:button forKey:@"button"];
	[button release];
	[[button cell] setControlSize:NSMiniControlSize];

	NSTextField *txtField = [[NSTextField alloc] initWithFrame:
		NSMakeRect(54, NSMaxY(button.frame)+4, self.frame.size.width-54, 17)];
	[self addSubview:txtField];
	[_privData setObject:txtField forKey:@"textField"];
	[txtField release];

	[self commonInit];
}

-(void)commonInit
{
	NSImageView *imgView = [_privData objectForKey:@"imgView"];
	[imgView setAutoresizingMask:NSViewNotSizable];
	[imgView setEditable:NO];
	NSButton *button = [_privData objectForKey:@"button"];
	[button setTitle:NSLocalizedString(@"Select", @"title of button to select a file")];
	[button setTarget:self];
	[button setAction:@selector(promptForFile:)];
	[button setAutoresizingMask:NSViewNotSizable];
	[button setBezelStyle:NSRoundedBezelStyle];
	[button setButtonType:NSMomentaryPushInButton];
	[button setBordered:YES];
	[button setFont:[NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSMiniControlSize]]];
	NSTextField *txtField = [_privData objectForKey:@"textField"];
	[txtField setAutoresizingMask:NSViewMinXMargin|NSViewWidthSizable];
	[txtField setEditable:NO];
	[txtField setSelectable:YES];
	[txtField setDrawsBackground:NO];
	[txtField setBordered:NO];
}

@synthesize theFile=__theFile, filesAreAcceptable, foldersAreAcceptable;
@synthesize applicationsAreAcceptable, showsHiddenFiles, showsPackageContents;
@synthesize acceptableFileTypes;
@end
