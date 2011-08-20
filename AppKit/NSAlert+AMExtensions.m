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
-(void)beginSheetModalForWindow:(NSWindow*)window completionHandler:(AMAlertCompletionBlock)cblock
{
	AMAlertDelegate *del = [[AMAlertDelegate alloc] initWithBlock:cblock];
	[self beginSheetModalForWindow:window 
					 modalDelegate:del 
					didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:)
					   contextInfo:nil];
}
@end
