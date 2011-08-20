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
@end
