//
//  UIScreen+AMExtensions.m
//
//  Created by Mark Lilback on 4/9/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import "UIScreen+AMExtensions.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation  UIScreen (AMExtensions)

+(BOOL)isRetinaDisplay
{
	static dispatch_once_t pred;
	static BOOL isRetina=NO;
	
	dispatch_once(&pred, ^{ 
		size_t size;
		sysctlbyname("hw.machine", NULL, &size, NULL, 0);
		char *machine = malloc(size);
		sysctlbyname("hw.machine", machine, &size, NULL, 0);
		NSString *platform = [NSString stringWithUTF8String:machine];
		free(machine);
		if ([platform isEqualToString:@"iPad1,1"]) {
			isRetina = NO;	// iPad 1
		}
		else if ([platform isEqualToString:@"iPhone3,1"]) {
			isRetina = YES;	// iPhone 4
		}
		else if ([[UIScreen mainScreen] scale] >= 2.0) {
			isRetina = YES;	// some other device:
		}
	});
	
	return isRetina;
}

@end
