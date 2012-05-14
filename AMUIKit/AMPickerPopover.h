//
//  AMPickerPopover.h
//  Vyana
//
//  Created by Mark Lilback on 5/14/12.
//  Copyright 2012 Agile Monks. All rights reserved.
//

#import <Foundation/Foundation.h>

//only need to set the items, selectedItem, optional itemKey, and the changeHandler. 
// all use as a view controller is internal.
// setting items sets selectedItem to the first item, so it is advisable to set the itemKey first

@interface AMPickerPopover : UIViewController<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) IBOutlet UITextField *textField;
@property (nonatomic, copy) NSArray *items;
@property (nonatomic, copy) NSString *itemKey; //nil if the item is a string
@property (nonatomic, retain) id selectedItem;
@property (nonatomic, copy) BasicBlock1Arg changeHandler; //argument is the pickerpopover
@end
