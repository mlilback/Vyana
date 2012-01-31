//
//  AMLabel.h
//
//  Created by Mark Lilback on 2/17/11.
//  Copyright 2011 Agile Monks, LLC. All rights reserved.
//

typedef enum VerticalAlignment {
	VerticalAlignmentTop=0,
	VerticalAlignmentMiddle,
	VerticalAlignmentBottom,
} VerticalAlignment;


@interface AMLabel : UILabel {
	@private
	VerticalAlignment _vertAlign;
}

@property (nonatomic, assign) VerticalAlignment verticalAlignment;
 
@end
