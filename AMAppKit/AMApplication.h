//
//  AMApplication.h
//
//  Created by Mark Lilback on 3/27/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: NA
//

#import <Foundation/Foundation.h>

/** 
 	@class AMApplication
	@brief Autoloads defaults from property list

 	This subclass will look for a resource file named DefaultDefaults.plist. If found,
 	it will call [[NSUserDefaults standardUserDefaults] registerDefaults:dict] with
 	the contents of that file.
*/

@interface AMApplication : NSApplication {
}
/**	If the FScript framework is installed
	in the computer or user's Frameworks folder, this will load its menu item.
	see  http://www.fscript.org/
*/
-(void)loadFScriptIfAvailable;

/** set to YES when the termination process starts */
@property (nonatomic, readonly) BOOL isTerminating;
@end
