//
//  A<GearMenuController.h
//
//  Created by Mark Lilback on 2/8/11.
//  Copyright 2011 Agile Monks, LLC. All rights reserved.
//

/* menuObjects can be: 
	1) a string. in that case, menuObjectTitleKey should be nil.
	2) a custom object. in that case, the menu will use menuObjectTitleKey on the object
		to get a string value to display.
	3) an instance of AMGearMenuItem. In that case, the data in that object will be used.
		In this case, a delegate is not required and the delegate method will NOT be called
		even if a delegate is set.  The argument to the action will be the menu item.
*/

@protocol AMGearMenuDelegate
-(void)gearMenuSelected:(id)selectedObject;
@end

@interface AMGearMenuItem : NSObject
+(AMGearMenuItem*)gearMenuItem:(NSString*)inTitle target:(id)inTarget action:(SEL)inAction
	userInfo:(id)userInfo;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, retain) id userInfo;
@end

@interface AMGearMenuController : UITableViewController
@property (nonatomic, retain) NSArray *menuObjects;
@property (nonatomic, copy) NSString *menuObjectTitleKey;
@property (nonatomic, assign) id<AMGearMenuDelegate> delegate;
@property (nonatomic, retain) id selectedMenuObject;

@end
