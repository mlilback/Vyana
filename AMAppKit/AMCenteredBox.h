//
//  AMCenteredBox.h
//  AMSharedCode
//
//  Created by Mark Lilback on Sun Jan 25 2004.
//  Copyright 2004-2010 Agile Monks, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 \class AMCenteredBox
 \brief A NSBox subclass that centers itself inside its superview
 
 */

@interface AMCenteredBox : NSBox {
@private
	CGFloat	_offsetFromTop;
	BOOL	_centerVert;
	BOOL	_centerHoriz;
}
@property (nonatomic, assign) BOOL centersVertically;
@property (nonatomic, assign) BOOL centersHorizontally;

@end
