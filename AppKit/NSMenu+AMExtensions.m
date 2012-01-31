//
//  NSMenu+AMExtensions.m
//  Vyana
//
//  Created by Mark Lilback on 10/5/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import "NSMenu+AMExtensions.h"
#import "MAZeroingWeakRef.h"
#import <objc/runtime.h>

NSString * const  kAMMenuRepObjKey = @"com.agilemonks.Vyana.NSMenuRepObject";

@implementation NSMenu (AMExtensions)
-(id)representedObject
{
	MAZeroingWeakRef *wkRef = objc_getAssociatedObject(self, kAMMenuRepObjKey);
	return [wkRef target];
}
-(void)setRepresentedObject:(id)obj
{
	MAZeroingWeakRef *wkRef = obj ? [[MAZeroingWeakRef alloc] initWithTarget:obj] : nil;
	objc_setAssociatedObject(self, kAMMenuRepObjKey, wkRef, OBJC_ASSOCIATION_RETAIN);
	[wkRef release];
}
@end
