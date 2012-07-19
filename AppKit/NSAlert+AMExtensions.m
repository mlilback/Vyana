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
@end


@implementation AMAlertDelegate
-(id)initWithBlock:(AMAlertCompletionBlock)ablock
{
	self = [super init];
	__cblock = [ablock copy];
	return self;
}
-(void)dealloc
{
	[__cblock release];
	[super dealloc];
}
- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
	__cblock(alert, returnCode);
	[self autorelease];
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
	AMAlertDelegate *del = [[AMAlertDelegate alloc] initWithBlock:cblock];
	[self beginSheetModalForWindow:window 
					 modalDelegate:del 
					didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:)
					   contextInfo:nil];
}
@end
