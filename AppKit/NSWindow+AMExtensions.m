//
//  NSWindow+AMExtensions.m
//  Vyana
//
//  Created by Mark Lilback on 10/27/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import "NSWindow+AMExtensions.h"

@implementation NSWindow (AMExtensions)
-(BOOL)endEditing
{
	BOOL success;
	id responder = [self firstResponder];
	
	// If we're dealing with the field editor, the real first responder is
	// its delegate.
	
	if ( (responder != nil) && [responder isKindOfClass:[NSTextView class]] && [(NSTextView*)responder isFieldEditor] )
		responder = ( [[responder delegate] isKindOfClass:[NSResponder class]] ) ? [responder delegate] : nil;
	
	success = [self makeFirstResponder:nil];
	
	// Return first responder status.
	
	if ( success && responder != nil )
		[self makeFirstResponder:responder];
	
	return success;
}

- (void)forceEndEditing
{
	[self endEditingFor:nil];
}

-(NSString*)responderChainDescription
{
	NSMutableString *s = [NSMutableString string];
	NSResponder *r = [self firstResponder];
	while (nil != r) {
		[s appendFormat:@"%@\n", [r valueForKey:@"debugDescription"]];
		r = [r nextResponder];
	}
	return s;
}

@end
