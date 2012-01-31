//
//  NSWindow+AMExtensions.h
//  Vyana
//
//  Created by Mark Lilback on 10/27/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface NSWindow (AMExtensions)

//debugging convience that returns a string with each object in the responder chain on a line
-(NSString*)responderChainDescription;

-(BOOL)endEditing;
-(void)forceEndEditing;
@end
