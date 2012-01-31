//
//  NSFileHandle+AMExtensions.m
//
//  Created by Mark Lilback on 10/4/2010.
//  Copyright 2010-11 Agile Monks, LLC. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: 4.1
//

#import "NSFileHandle+AMExtensions.h"

@implementation NSFileHandle (AMExtensions)
+(id)fileHandleForWritingTemporaryFileWithPrefix:(NSString*)baseFileName filePath:(NSString**)outFilePath
{
	if ([baseFileName length] < 1)
		baseFileName = @"amtmp" ;
	baseFileName = [baseFileName stringByAppendingString:@".XXXXXX"];
	NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:baseFileName];
	char *tmpFileNameString = strdup([filePath fileSystemRepresentation]);
	int fd = mkstemp(tmpFileNameString);
	filePath = [[NSFileManager defaultManager] stringWithFileSystemRepresentation:tmpFileNameString
		length:strlen(tmpFileNameString)];
	free(tmpFileNameString);
	if (-1 == fd) {
		return nil;
	}
	if (outFilePath)
		*outFilePath = filePath;
	return [[[NSFileHandle alloc] initWithFileDescriptor:fd closeOnDealloc:YES] autorelease];
}
@end
