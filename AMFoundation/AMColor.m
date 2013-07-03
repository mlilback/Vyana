//
//  AMColor.m
//  Vyana
//
//  Created by Mark Lilback on 3/11/13.
//  Copyright 2013 Agile Monks. All rights reserved.
//

#import "AMColor.h"

#if TARGET_OS_IPHONE
#import "UIColor+AMExtensions.h"
#else
#import "NSColor+AMExtensions.h"
#endif

@interface AMColor ()
@property (strong, readwrite) id nativeColor;
@end

@implementation AMColor

+(id)colorWithHexString:(NSString*)hexStr
{
	return [[[AMColor alloc] initWithHexString:hexStr] autorelease];
}
+(id)colorWithColor:(id)sysColor
{
	return [[[AMColor alloc] initWithColor:sysColor] autorelease];
}


-(id)initWithHexString:(NSString*)hexStr
{
	self = [super init];
#if TARGET_OS_IPHONE
	self.nativeColor = [UIColor colorWithHexString:hexStr];
#else
	self.nativeColor = [NSColor colorWithHexString:hexStr];
#endif
	return self;
}

-(id)initWithColor:(id)sysColor
{
	self = [super init];
	self.nativeColor = sysColor;
	return self;
}

-(id)colorWithAlpha:(CGFloat)alpha
{
	id c = [self.nativeColor colorWithAlphaComponent:alpha];
	return [AMColor colorWithColor:c];
}

-(CGColorRef)CGColor
{
	return (CGColorRef)[self.nativeColor CGColor];
}

@end
