//
//  AMODBEditor.m
//  Vyana
//
//  Created by Mark Lilback on 1/15/12.
//  Copyright (c) 2012 Agile Monks. All rights reserved.
//

#import "AMODBEditor.h"
#import "ODBEditorSuite.h"
#import "NSAppleEventDescriptor+AMExtensions.h"
#import "MAZeroingWeakRef.h"

#define kEditDict_ClientKey @"ClientWeakRef"
#define kEditDict_ContextKey @"Context"
#define kEditDict_PathKey @"Path"
#define kEditDict_IsStringKey @"IsString"

@interface AMODBEditor() {
	UInt32 _signature;
}
@property (nonatomic, strong) NSMutableDictionary *filesBeingEdited;
-(id)initPrivate;
-(BOOL)launchExternalEditor;
-(NSString *)tempFileForEditingString:(NSString *)string;
-(void)handleModifiedFileEvent:(NSAppleEventDescriptor *)event 
				withReplyEvent:(NSAppleEventDescriptor *)replyEvent;
-(void)handleClosedFileEvent:(NSAppleEventDescriptor *)event 
			  withReplyEvent:(NSAppleEventDescriptor *)replyEvent;
- (BOOL)editFile:(NSString*)path 
 isEditingString:(BOOL)isString 
	displayTitle:(NSString*)displayTitle 
	   forClient:(id<AMODBEditorClient>)client 
		 context:(NSDictionary *)context;
@end

@implementation AMODBEditor

+(id)sharedEditor
{
    static dispatch_once_t onceQueue;
    static AMODBEditor *aMODBEditor = nil;
	
    dispatch_once(&onceQueue, ^{ aMODBEditor = [[self alloc] initPrivate]; });
    return aMODBEditor;
}

-(id)initPrivate
{
	self = [super init];
	UInt32 packageType=0, packageCreator=0;
	CFBundleGetPackageInfo(CFBundleGetMainBundle(), &packageType, &packageCreator);
	_signature = packageCreator;
	self.editorBundleIdentifier = @"com.barebones.BBEdit";
	self.filesBeingEdited = [NSMutableDictionary dictionary];

	NSAppleEventManager *aem = [NSAppleEventManager sharedAppleEventManager];
	[aem setEventHandler:self 
			 andSelector:@selector(handleModifiedFileEvent:withReplyEvent:) 
		   forEventClass:kODBEditorSuite 
			  andEventID:kAEModifiedFile];
	[aem setEventHandler:self 
			 andSelector:@selector(handleClosedFileEvent:withReplyEvent:) 
		   forEventClass:kODBEditorSuite 
			  andEventID:kAEClosedFile];
	self.tempFilePrefix = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
	return self;
}

-(void)dealloc
{
	NSAppleEventManager *aem = [NSAppleEventManager sharedAppleEventManager];
	[aem removeEventHandlerForEventClass:kODBEditorSuite andEventID:kAEModifiedFile];
	[aem removeEventHandlerForEventClass:kODBEditorSuite andEventID:kAEClosedFile];
}

#pragma mark - abort methods

-(void)abortEditingFile:(NSString*)path
{
	if (nil == [self.filesBeingEdited objectForKey:path])
		NSLog(@"AMODBEditor: no active session for %@", path);
	//TODO: delete the file if it was a temp file
	[self.filesBeingEdited removeObjectForKey:path];
}

-(void)abortAllEditingSessionsForClient:(id)client
{
	//TODO: delete the file(s) if it was a temp file
	NSMutableSet *keysToRemove = [NSMutableSet set];
	for (NSDictionary *dict in self.filesBeingEdited.allValues) {
		id dclient = [[dict objectForKey:kEditDict_ClientKey] target];
		if (dclient == client)
			[keysToRemove addObject:[dict objectForKey:kEditDict_PathKey]];
	}
	[self.filesBeingEdited removeObjectsForKeys:keysToRemove.allObjects];
}

#pragma mark - editing

-(BOOL)editFile:(NSString*)path 
   displayTtile:(NSString*)displayTitle
	  forClient:(id<AMODBEditorClient>)client 
		context:(NSDictionary*)context
{
	return [self editFile:path isEditingString:NO displayTitle:displayTitle forClient:client context:context];
}

-(BOOL)editString:(NSString*)string 
	 displayTitle:(NSString*)displayTitle
		forClient:(id<AMODBEditorClient>)client 
		  context:(NSDictionary*)context
{
	NSString *path = [self tempFileForEditingString:string];
	if (path)
		return [self editFile:path isEditingString:YES displayTitle:displayTitle forClient:client context:context];
	return NO;
}

#pragma - internal methods

- (BOOL)launchExternalEditor
{
	BOOL success = NO;
	BOOL running = NO;
	NSWorkspace	*workspace = [NSWorkspace sharedWorkspace];
	NSArray	*runningApplications = [workspace runningApplications];
	NSEnumerator *enumerator = [runningApplications objectEnumerator];
	NSRunningApplication *applicationInfo;
	
	while (nil != (applicationInfo = [enumerator nextObject])) {

		NSString *bundleIdentifier = [applicationInfo bundleIdentifier];

		if ([bundleIdentifier isEqualToString: self.editorBundleIdentifier]) {
			running = YES;
			// bring the app forward
			success = [workspace launchApplication:[[applicationInfo bundleURL] path]];
			break;
		}
	}
	if (running == NO) {
		success = [workspace launchAppWithBundleIdentifier:self.editorBundleIdentifier 
												   options:NSWorkspaceLaunchDefault 
							additionalEventParamDescriptor:nil 
										  launchIdentifier:NULL];
	}
	return success;
}

-(NSString *)tempFileForEditingString:(NSString *)string 
{
	NSUInteger tmpSequence=0;
	
	NSString *path = nil;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *escapedPathKey = [self.tempFilePrefix stringByReplacingOccurrencesOfString:@"/" withString:@"-"];	
	NSString *pathExtension = [escapedPathKey pathExtension];
	
	if ([pathExtension isEqualToString:@""])
		pathExtension = @"txt";
	
	do {
		path = [NSString stringWithFormat: @"%@ %03ld.%@", [escapedPathKey stringByDeletingPathExtension], 
				++tmpSequence, pathExtension];
		path = [NSTemporaryDirectory() stringByAppendingPathComponent: path];
	} while ([fileManager fileExistsAtPath:path]);
	
	NSError *error = nil;
	if (NO == [string writeToFile:path atomically:NO encoding:NSUTF8StringEncoding error:&error]) {
		NSLog([error description], nil);
		path = nil;
	}
	
	return [NSURL fileURLWithPath:path];
}

- (BOOL)editFile:(NSString*)path 
 isEditingString:(BOOL)isString 
	displayTitle:(NSString*)displayTitle 
	   forClient:(id<AMODBEditorClient>)client 
		 context:(NSDictionary *)context
{    
    path = [path stringByResolvingSymlinksInPath];
	BOOL success = NO;
	OSStatus status = noErr;
	NSData *targetBundleID = [self.editorBundleIdentifier dataUsingEncoding: NSUTF8StringEncoding];
	NSAppleEventDescriptor *targetDescriptor = [NSAppleEventDescriptor descriptorWithDescriptorType: typeApplicationBundleID data: targetBundleID];
	NSAppleEventDescriptor *ae = [NSAppleEventDescriptor appleEventWithEventClass: kCoreEventClass
																				  eventID: kAEOpenDocuments
																		 targetDescriptor: targetDescriptor
																				 returnID: kAutoGenerateReturnID
																			transactionID: kAnyTransactionID];
	NSAppleEventDescriptor  *replyDescriptor = nil;
	NSAppleEventDescriptor  *errorDescriptor = nil;
	AEDesc reply = {typeNull, NULL};														
	
	[self launchExternalEditor];
	
	[ae setParamDescriptor:[NSAppleEventDescriptor descriptorWithFileURL: [NSURL fileURLWithPath:path]] 
				forKeyword:keyDirectObject];
	[ae setParamDescriptor:[NSAppleEventDescriptor descriptorWithTypeCode: _signature] 
				forKeyword:keyFileSender];
	if (displayTitle != nil)
		[ae setParamDescriptor:[NSAppleEventDescriptor descriptorWithString:displayTitle] 
					forKeyword:keyFileCustomPath];
	
	AESendMessage([ae aeDesc], &reply, kAEWaitReply, kAEDefaultTimeout);
	
	if (status == noErr) {
		replyDescriptor = [[[NSAppleEventDescriptor alloc] initWithAEDescNoCopy: &reply] autorelease];
		errorDescriptor = [replyDescriptor paramDescriptorForKeyword: keyErrorNumber];
		
		if (errorDescriptor != nil) {
			status = [errorDescriptor int32Value];
		}
		
		if (status == noErr) {
			// save off some information that we'll need when we get called back
			
			NSMutableDictionary *dict = [NSMutableDictionary dictionary];
			MAZeroingWeakRef *clientRef = [[MAZeroingWeakRef alloc] initWithTarget:client];
			[dict setObject:clientRef forKey:kEditDict_ClientKey];
			if (context)
				[dict setObject:context forKey:kEditDict_ContextKey];
			[dict setObject:path forKey:kEditDict_PathKey];
			[dict setObject:[NSNumber numberWithBool:isString] forKey:kEditDict_IsStringKey];
			[self.filesBeingEdited setObject:dict forKey:path];
		}
	}
	
	success = (status == noErr);
	
	return success;
}


#pragma mark - apple event handlers

- (void)handleModifiedFileEvent:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent
{
	NSAppleEventDescriptor *fpDescriptor = [[event paramDescriptorForKeyword: keyDirectObject] coerceToDescriptorType: typeFileURL];
	NSString *urlString = [[[NSString alloc] initWithData: [fpDescriptor data] encoding: NSUTF8StringEncoding] autorelease];
	NSString *path = [[[NSURL URLWithString: urlString] path] stringByResolvingSymlinksInPath];
	NSAppleEventDescriptor	*nfpDescription = [[event paramDescriptorForKeyword: keyNewLocation] coerceToDescriptorType: typeFileURL];
	NSString *newUrlString = [[[NSString alloc] initWithData: [nfpDescription data] encoding: NSUTF8StringEncoding] autorelease];
	NSString *newPath = [[NSURL URLWithString: newUrlString] path];
	NSDictionary *dictionary = nil;
	NSError *error = nil;
	
	dictionary = [self.filesBeingEdited objectForKey:path];
	
	if (dictionary != nil) {
		id  client		= [[dictionary objectForKey: kEditDict_ClientKey] target];
		id isString		= [dictionary objectForKey: kEditDict_IsStringKey];
		NSDictionary *context	= [dictionary objectForKey: kEditDict_ContextKey];
		
		if(isString) {
			NSString *stringContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
			if (stringContents) {
				[client odbEditor:self didModifyString:stringContents context:context];
			} else {
				NSLog([error description], nil);
			}
		} else {
			[client odbEditor:self didModifyFile:path newLocation:newPath context:context];
		}
		
		if(newPath) {
			[self.filesBeingEdited removeObjectForKey: path];
	    }
	} else {
		NSLog(@"Got ODB editor event for unknown file.");
	}
}

- (void)handleClosedFileEvent:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent
{
	NSAppleEventDescriptor  *descriptor = [[event paramDescriptorForKeyword: keyDirectObject] coerceToDescriptorType: typeFileURL];
	NSString				*urlString = [[[NSString alloc] initWithData: [descriptor data] encoding: NSUTF8StringEncoding] autorelease];
	NSString				*fileName = [[[NSURL URLWithString: urlString] path] stringByResolvingSymlinksInPath];
	NSDictionary			*dictionary = nil;
	NSError *error = nil;
	
	dictionary = [self.filesBeingEdited objectForKey:fileName];
	
	if (dictionary != nil) {
		id client		= [[dictionary objectForKey: kEditDict_ClientKey] target];
		id isString		= [dictionary objectForKey: kEditDict_IsStringKey];
		NSDictionary *context	= [dictionary objectForKey: kEditDict_ContextKey];
		
		if(isString) {
			NSString	*stringContents = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:fileName] encoding:NSUTF8StringEncoding error:&error];
			if (stringContents) {
				[client odbEditor:self didFinishEdit:stringContents context:context];
			} else {
				NSLog([error description], nil);
			}
		} else {
			[client odbEditor:self didCloseFile:fileName context:context];
		}
	} else {
		NSLog(@"Got ODB editor event for unknown file.");
	}
	
	[self.filesBeingEdited removeObjectForKey: fileName];
}

#pragma mark - synthesizers

@synthesize editorBundleIdentifier;
@synthesize filesBeingEdited;
@synthesize tempFilePrefix;
@end
