//
//  NSAlert+AMExtensions.m
//  Vyana
//
//  Created by Mark Lilback on 8/19/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import "NSAlert+AMExtensions.h"

@interface AMAlertDelegate :NSObject<NSAlertDelegate> {
	AMAlertCompletionBlock __cblock;
}
@property (nonatomic, strong) NSAlert *alert;
@end


@implementation AMAlertDelegate
-(id)initWithBlock:(AMAlertCompletionBlock)ablock alert:(NSAlert*)inAlert
{
	self = [super init];
	__cblock = [ablock copy];
	self.alert = inAlert;
	return self;
}
-(void)dealloc
{
	[__cblock release];
	self.alert=nil;
	[super dealloc];
}
- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
	__cblock(alert, returnCode);
	//the following is to match the hidden call to retain in beginSheetModalForWindow
	[self performSelector:@selector(autorelease)];
}
@end


@implementation NSAlert(AMExtensions)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wformat-security"
+(void)displayAlertWithTitle:(NSString*)title details:(NSString*)details
{
	NSAlert *alert = [NSAlert alertWithMessageText:title defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:details];
	if ([NSApp mainWindow])
		[alert beginSheetModalForWindow:[NSApp mainWindow] modalDelegate:nil didEndSelector:nil contextInfo:nil];
	else
		[alert runModal];
	[self autorelease];
}
#pragma clang diagnostic pop

-(void)beginSheetModalForWindow:(NSWindow*)window completionHandler:(AMAlertCompletionBlock)cblock
{
	AMAlertDelegate *del = [[AMAlertDelegate alloc] initWithBlock:cblock alert:self];
	//this "hidden" from clang call is countered by autorelease in  alertDidEnd
	[del performSelector:@selector(retain)];
	[self beginSheetModalForWindow:window 
					 modalDelegate:del 
					didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:)
					   contextInfo:nil];
	[del release];
}
@end
