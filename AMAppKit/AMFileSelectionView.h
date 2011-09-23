//
//  AMFileSelectionView.h
//
//  Created by Mark Lilback on 10/16/10.
//  Copyright 2010-11 Agile Monks, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**	\class AMFileSelectionView
 	\brief A widget for selecting/dropping a file
 
 	Should be at least 150 points wide, and either 30 or 48 pixels tall. The 30 pixel one will grow
	the image size to fit the rect, keeping the button and text centered. The 48 version just
	extends the text to the right as the parent grows.
*/

@interface AMFileSelectionView : NSBox
@property (nonatomic, retain) NSURL *theFile;///<the file selected
@property (assign) BOOL filesAreAcceptable; ///<defaults to YES
@property (assign) BOOL foldersAreAcceptable; ///<defaults to NO
@property (assign) BOOL applicationsAreAcceptable; ///<defaults to NO
@property (assign) BOOL showsHiddenFiles; ///<defaults to NO
@property (assign) BOOL showsPackageContents; ///<defaults to NO
///array of path extensions that are acceptable.
@property (nonatomic, copy) NSArray *acceptableFileTypes;

///causes a NSOpenPanel to be displayed
-(IBAction)promptForFile:(id)sender;
@end
