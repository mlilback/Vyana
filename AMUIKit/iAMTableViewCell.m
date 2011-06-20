//
//  iAMTableViewCell.m
//
//  Created by Mark Lilback on 3/10/11.
//  Copyright 2011 Agile Monks, LLC. All rights reserved.
//

#import "iAMTableViewCell.h"
#import "NSArray+AMExtensions.h"

@implementation iAMTableViewCell
+(UITableViewCellStyle)defaultStyle
{
	return UITableViewCellStyleDefault;
}

+(NSString*)cellIdentifier
{
	return NSStringFromClass([self class]);
}

+(NSString*)nibName
{
	return [self cellIdentifier];
}

+(id)cellForTableView:(UITableView*)aTableView
{
	return [self cellForTableView:aTableView withIdentifier:[self cellIdentifier]];
}

+(id)cellForTableView:(UITableView*)aTableView withIdentifier:(NSString*)ident
{
	id cell = [aTableView dequeueReusableCellWithIdentifier:ident];
	if (nil == cell)
		cell = [[[self alloc] initWithCellIdentifier:ident] autorelease];
	return cell;
}

-(id)initWithCellIdentifier:(NSString*)anIdent
{
	if ((self = [super initWithStyle:[[self class] defaultStyle] reuseIdentifier:anIdent])) {
		UINib *nib = [UINib nibWithNibName:[[self class] nibName] bundle:[NSBundle bundleForClass:[self class]]];
		NSArray *objs = [nib instantiateWithOwner:self options:nil];
		if (!IsEmpty(objs)) {
			id nibView = [objs firstObject];
			ZAssert([nibView isKindOfClass:[UIView class]], @"first object in nib isn't a UIView");
			self.frame = [nibView bounds];
			[self addSubview:[objs firstObject]];
		}
	}
	return self;
}

-(CGFloat)rowHeight
{
	if (self.contentView)
		return self.contentView.bounds.size.height;
	return 44.0f; //not specifically documented, but it is the default size
}

@end
