//
//  NSAppleScript+AMExtensions.m
//
//  Created by Mark Lilback on 10/25/10.
//  Copyright 2010-11 Agile Monks, LLC. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: NA
//

#import "NSAppleScript+AMExtensions.h"

//constants from Carbon so we don't have to include and link to the whole framework
enum {
  kASSubroutineEvent            = 'psbr',
  keyASSubroutineName           = 'snam',
  typeAppleScript               = 'ascr',
  keyASUserRecordFields			= 'usrf'
};

NSString * const AMScriptEngineErrorRangeKey = @"AMScriptEngineErrorRangeKey";

@implementation NSAppleScript (AMExtensions)
-(id)callHandler:(NSString*)handlerName withParameter:(NSAppleEventDescriptor*)param
	error:(NSError**)outError
{
	ProcessSerialNumber PSN = {0, kCurrentProcess};
	NSAppleEventDescriptor *theAddress=nil;
	
	/* create the target address descriptor specifying our own process as the target */
	if ( (theAddress = [NSAppleEventDescriptor descriptorWithDescriptorType:typeProcessSerialNumber 
			bytes:&PSN length:sizeof(PSN)]) )
	{
		NSAppleEventDescriptor *theEvent;
		/* create a new Apple event of type typeAppleScript/kASSubroutineEvent */
		if ( (theEvent = [NSAppleEventDescriptor appleEventWithEventClass:typeAppleScript 
						eventID:kASSubroutineEvent targetDescriptor:theAddress 
						returnID:kAutoGenerateReturnID transactionID:kAnyTransactionID]) )
		{
			NSAppleEventDescriptor* theHandlerName;
			/* create a descriptor containing the handler's name.  AppleScript handler
			names must be converted to lowercase before including them in a call
			subroutine Apple event.  */
			if ( (theHandlerName = [NSAppleEventDescriptor descriptorWithString:
													[handlerName lowercaseString]]) )
			{
				NSAppleEventDescriptor *theResult;
				/* add the handler's name to the Apple event using the
				keyASSubroutineName keyword */
				[theEvent setDescriptor:theHandlerName forKeyword:keyASSubroutineName];
				/* add the parameter list.  If none was specified, then create an empty one */
				if ( param != nil ) {
					[theEvent setDescriptor:param forKeyword:keyDirectObject];
				} else {
					NSAppleEventDescriptor* paramList = [NSAppleEventDescriptor listDescriptor];
					[theEvent setDescriptor:paramList forKeyword:keyDirectObject];
				}
				/* send the subroutine event to the script  */
				NSDictionary *error=nil;
				theResult = [self executeAppleEvent:theEvent error:&error];
				if (error && outError)
					*outError = [self createNSErrorFromASErrorInfo:error];
				/* return whatever result the script returned */
				return theResult;
			}
		}
	}
	return nil;
}

-(NSError*)createNSErrorFromASErrorInfo:(NSDictionary*)errorInfo
{
	NSMutableDictionary *einfo = [NSMutableDictionary dictionary];
	if ([errorInfo objectForKey:NSAppleScriptErrorBriefMessage]) {
		[einfo setObject:[errorInfo objectForKey:NSAppleScriptErrorBriefMessage] 
			forKey:NSLocalizedDescriptionKey];
	}
	if ([errorInfo objectForKey:NSAppleScriptErrorMessage]) {
		[einfo setObject:[errorInfo objectForKey:NSAppleScriptErrorMessage] 
			forKey:NSLocalizedFailureReasonErrorKey];
	}
	if ([errorInfo objectForKey:NSAppleScriptErrorRange]) {
		[einfo setObject:[errorInfo objectForKey:NSAppleScriptErrorRange] 
			forKey:AMScriptEngineErrorRangeKey];
	}
	return [NSError errorWithDomain:NSOSStatusErrorDomain
		code:[[errorInfo objectForKey:NSAppleScriptErrorNumber] integerValue] 
		userInfo:einfo];
}

@end
