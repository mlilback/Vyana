//
//  AMControlledView.h
//
//  Created by Mark Lilback on 2/9/2010.
//  Copyright 2010-11 Agile Monks, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 	\class AMControlledView
 	\brief A NSView subclass that tracks its view controller
 
 	Sometimes you'd like to have a view be able to refer back to its controller,
	for example, to get the undo manager. It also inserts the view controller
 	into the responder chain above the view.
 */

@interface AMControlledView : NSView
/// \brief 
/// When compiled with Lion as the minimum target, the property will be weak.
/// On older OS versions, it is a unretained pointer.
#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_7
@property (nonatomic, weak) IBOutlet NSViewController *viewController;
#else
@property (nonatomic, assign) IBOutlet NSViewController *viewController;
#endif
@end
