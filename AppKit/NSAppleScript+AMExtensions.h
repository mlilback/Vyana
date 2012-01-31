//
//  NSAppleScript+AMExtensions.h
//
//  Created by Mark Lilback on 10/25/10.
//  Copyright 2010-11 Agile Monks, LLC. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: NA
//

#import <Cocoa/Cocoa.h>

///constant for error userInfo dictionary that contains an NSValue with the NSRange of 
/// the offending source code
extern NSString * const AMScriptEngineErrorRangeKey;

@interface NSAppleScript (AMExtensions)
-(id)callHandler:(NSString*)handlerName withParameter:(NSAppleEventDescriptor*)param
	error:(NSError**)outError;
-(NSError*)createNSErrorFromASErrorInfo:(NSDictionary*)errorInfo;
@end
