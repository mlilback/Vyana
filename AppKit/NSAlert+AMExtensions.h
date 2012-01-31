//
//  NSAlert+AMExtensions.h
//  Vyana
//
//  Created by Mark Lilback on 8/19/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

//the second parameter is the button index that was clicked.
typedef void (^AMAlertCompletionBlock)(NSAlert*, NSInteger);

@interface NSAlert(AMExtensions)
-(void)beginSheetModalForWindow:(NSWindow*)window completionHandler:(AMAlertCompletionBlock)cblock;

///this method displays an alert with a single OK button. It displays as a sheet
/// on [NSApp mainWindow], or as a standaline dialog.
+(void)displayAlertWithTitle:(NSString*)title details:(NSString*)details;
@end
