//
//  AMPickerPopover.m
//  Vyana
//
//  Created by Mark Lilback on 5/14/12.
//  Copyright 2012 Agile Monks. All rights reserved.
//

#import "AMBlockUtils.h"
#import "AMPickerPopover.h"
#import "NSArray+AMExtensions.h"

@interface AMPickerPopover() <UIPopoverControllerDelegate>
@property (nonatomic, strong) UIPopoverController *popover;
@property (nonatomic, strong) UIPickerView *picker;
@end

@implementation AMPickerPopover

-(void)loadView
{
	UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
	self.contentSizeForViewInPopover = picker.frame.size;
	picker.delegate = self;
	picker.dataSource = self;
	picker.showsSelectionIndicator=YES;
	self.picker = picker;
	UIView *view = [[UIView alloc] initWithFrame:picker.frame];
	[view addSubview:picker];
	self.view = view;
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
	self.popover = nil;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	//show the popup
	if (nil == self.popover) {
		self.popover = [[UIPopoverController alloc] initWithContentViewController:self];
		self.popover.delegate = self;
		self.popover.popoverContentSize = self.view.frame.size;
	}
	if ([self.popover isPopoverVisible]) {
		[self.popover dismissPopoverAnimated:YES];
	} else {
		NSInteger idx = [self.items indexOfObject:self.selectedItem];
		if (idx < 0)
			idx = 1;
		[self.picker selectRow:idx inComponent:0 animated:YES];
		[self.popover presentPopoverFromRect:self.textField.bounds inView:self.textField permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
	return NO;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return self.items.count;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	id obj = [self.items objectAtIndex:row];
	if (self.itemKey)
		obj = [obj valueForKey:self.itemKey];
	return obj;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	self.selectedItem = [self.items objectAtIndex:row];
	if (self.changeHandler)
		self.changeHandler(self);
}

-(void)setSelectedItem:(id)val
{
	_selectedItem = val;
	if (self.itemKey)
		val = [val valueForKey:self.itemKey];
	self.textField.text = val;
}

-(void)setItems:(NSArray *)items
{
	_items = [items copy];
	self.selectedItem = [items firstObject];
}

-(void)setTextField:(UITextField *)textField
{
	_textField = textField;
	_textField.delegate = self;
}

@synthesize items=_items;
@synthesize selectedItem=_selectedItem;
@synthesize itemKey=_itemKey;
@synthesize changeHandler=_changeHandler;
@synthesize textField=_textField;
@synthesize popover=_popover;
@synthesize picker=_picker;
@end
