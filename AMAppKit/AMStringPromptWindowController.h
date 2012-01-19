//
//  AMStringPromptWindowController.h
//  Vyana
//
//  Created by Mark Lilback on 1/19/12.
//  Copyright 2012 Agile Monks. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AMStringPromptWindowController : NSWindowController
@property (nonatomic, copy) NSString *stringValue;
@property (nonatomic, copy) NSString *promptString;
@property (nonatomic, copy) NSString *okButtonTitle;
@property (nonatomic, copy) BOOL (^validationBlock)(NSString*);
@property (readonly) BOOL stringAcceptable;
-(IBAction)ok:(id)sender;
-(IBAction)cancel:(id)sender;

/**	The argument to the completionHandler will be either NSOkButton or NSCancelButton. */
-(void)displayModelForWindow:(NSWindow*)parentWindow completionHandler:(BasicBlock1IntArg)block;
@end
