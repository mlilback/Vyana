//
//  AMProcessInfo.m
//  Vyana
//
//  Created by Mark Lilback on 8/18/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import "AMProcessInfo.h"
#import <sys/sysctl.h>

static NSString *fullNameForPid(pid_t pid, int argLen);
static int getArgMaxLen();

@implementation AMProcessInfo

+(NSArray*)currentProcessList
{
	struct kinfo_proc *bsdProcs=nil;
	static const int sysname[] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0};
	size_t listLen=0, curLen=0;
	int i, argMaxLen= getArgMaxLen();
	
	int err = sysctl((int*)sysname, 4, NULL, &curLen, NULL, 0);
	if (0 != err) {
		//failed to get list
		NSLog(@"call to sysctl failed with err %d, errno %d", err, errno);
		return nil;
	}
	NSMutableArray *outArray = [NSMutableArray array];
	bsdProcs = calloc(sizeof(struct kinfo_proc), curLen);
	ZAssert(bsdProcs, @"calloc failed");
	listLen = curLen / sizeof(struct kinfo_proc);
	err = sysctl((int*)sysname, 4, bsdProcs, &curLen, NULL, 0);
	if (-1 == err) {
		//error
		NSLog(@"error!!!");
	}
	if (curLen > 0) {
		for (i=0; i < listLen; i++) {
			AMProcessInfo *aProcess = [[AMProcessInfo alloc] init];
			aProcess.pid = bsdProcs[i].kp_proc.p_pid;
			NSString *pname = fullNameForPid(aProcess.pid, argMaxLen);
			if (nil == pname)
				pname = [NSString stringWithUTF8String:bsdProcs[i].kp_proc.p_comm];
			aProcess.launchPath = pname;
			if (aProcess.pid > 0)
				[outArray addObject:aProcess];
			[aProcess release];
		}
	}
	free(bsdProcs);
	if (err != 0)
		outArray=nil;
	return outArray;
}

-(void)dealloc
{
	self.launchPath=nil;
	[super dealloc];
}

@synthesize launchPath;
@synthesize pid;
@end

static int getArgMaxLen()
{
	size_t size=sizeof(int);
	int argmax;
	int mib[3] = {CTL_KERN, KERN_ARGMAX, 0};
	sysctl(mib, 2, &argmax, &size, NULL, 0);
	return argmax;
}

static NSString *fullNameForPid(pid_t pid, int argMaxLen)
{
	NSString *str = nil;
	int mib[3] = {CTL_KERN, KERN_PROCARGS2, pid};
	size_t size = argMaxLen;
	 char *procarg=calloc(sizeof(char), size);
	int err = sysctl(mib, 3, procarg, &size, NULL, 0);
	if (err == 0 && procarg) {
		str = [NSString stringWithUTF8String: procarg + sizeof(int)];
	}
	free(procarg);
	return str;
}


