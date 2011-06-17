//
//  iAMTableViewCell.h
//
//  Created by Mark Lilback on 3/10/11.
//  Copyright 2011 Agile Monks, LLC. All rights reserved.
//

/**
	iAMTableViewCell
	
	This class encapsulates the deque/alloc code that all cells require. 
	It also optionally handles loading content from a nib. To use a nib, give
	 it the same name as the class (or override +nibName). The file owner should
	 be an object of the subclass. The first object in the nib should be a UIView
	 that will be added as a subview.
	
	If using a nib, your subclass only needs to define internal methods or possibly
	 override +nibName if you don't want to use the class name as the nib name.
	 The cell will be sized to fit the size of the view loaded from the nib.
	 
	If not using a nib, you'll likely want to override +defaultStyle and 
	 -initWithCellIdentifier.
*/

@interface iAMTableViewCell : UITableViewCell {
}

//defaults to default style
+(UITableViewCellStyle)defaultStyle;

//defaults to class name
+(NSString*)cellIdentifier;

//defaults to cellIdentifier
+(NSString*)nibName;

//dequeues the cell, or creates it if it doesn't exist
+(id)cellForTableView:(UITableView*)aTableView;

//default initializer
-(id)initWithCellIdentifier:(NSString*)anIdent;

//a convience method for data sources to get the row height if loaded from a nib. 
// otherwise, returns default height.
-(CGFloat)rowHeight;

@end
