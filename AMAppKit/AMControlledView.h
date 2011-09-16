//
//  AMControlledView.h
//
//  Created by Mark Lilback on 2/9/2010.
//  Copyright 2010-11 Agile Monks, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AMControlledView : NSView
#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_7
@property (nonatomic, weak) IBOutlet NSViewController *viewController;
#else
@property (nonatomic, assign) IBOutlet NSViewController *viewController;
#endif
@end
