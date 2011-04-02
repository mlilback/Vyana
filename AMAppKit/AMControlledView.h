//
//  AMControlledView.h
//
//  Created by Mark Lilback on 2/9/2010.
//  Copyright 2010-11 Agile Monks, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AMControlledView : NSView {
	@private
	NSViewController *__vc;
}
@property (nonatomic, assign) NSViewController *viewController;
@end
