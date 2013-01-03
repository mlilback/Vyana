//
//  AMActivity.m
//  Vyana
//
//  Created by Mark Lilback on 1/3/13.
//  Copyright 2013 Agile Monks. All rights reserved.
//

#import "Vyana-ios/AMBlockUtils.h"
#import "AMActivity.h"

@interface AMActivity()
@property (nonatomic, copy) NSString *amActivityType;
@property (nonatomic, copy) NSString *amTitle;
@property (nonatomic, copy) NSString *amImageName;
@end

@implementation AMActivity

-(id)initWithActivityType:(NSString*)actType title:(NSString*)actTitle image:(NSString*)imageName
{
	if ((self = [super init])) {
		self.amActivityType = actType;
		self.amTitle = actTitle;
		self.amImageName = imageName;
	}
	return self;
}


-(NSString*)activityType
{
	return self.amActivityType;
}

-(NSString*)activityTitle
{
	return self.amTitle;
}

-(UIImage*)activityImage
{
	return [UIImage imageNamed:self.amImageName];
}

-(BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
	return self.canPerformBlock(activityItems);
}

-(void)prepareWithActivityItems:(NSArray *)activityItems
{
	self.prepareBlock(activityItems);
}
@end
