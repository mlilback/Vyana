//
//  AMControlledView.h
//
//  Created by Mark Lilback on 2/9/2010.
//  Copyright 2010-11 Agile Monks, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 	@class AMControlledView
 	@brief A NSView subclass that tracks its view controller
 
 	Sometimes you'd like to have a view be able to refer back to its controller,
	for example, to get the undo manager. It also inserts the view controller
 	into the responder chain above the view.
 */

@interface AMControlledView : NSView
/** @brief 
	Ideally when compiled with Lion as the minimum target, the property would be weak. However,
	you can't make weak references to a subclass of NSViewController until Mountain Lion. 
 	So if you aren't careful, you can get BAD_ACCESS exceptions. To avoid this, make sure your 
 	view controller subclasses AMViewController, which will make sure this does not happen.
 	This shouldn't be an issue now that we're using a MAZeroingWeakRef to hold the ref, but...
*/
@property (nonatomic, assign) IBOutlet NSViewController *viewController;
@end

/** @brief
	If the viewController responds to any of these messages, they will be invoked instead of the
	default NSView implementation. There is no need to conform to this protocol as it is never
	checked for.
*/

@protocol AMControlledViewController <NSObject>
@optional
/** If implemented and YES is returned, the default NSView implementation is called. */
-(BOOL)shouldHandlePrintCommand:(id)sender;
/** IF implemented, used instead of the NSView implementation. */
-(NSString*)printJobTitle;
@end