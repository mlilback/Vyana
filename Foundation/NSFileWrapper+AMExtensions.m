//
//  NSFileWrapper+AMExtensions.m
//  Vyana
//
//  Created by Mark Lilback on 1/10/12.
//  Copyright (c) 2012 Agile Monks. All rights reserved.
//

#import "NSFileWrapper+AMExtensions.h"

@implementation NSFileWrapper (AMExtensions)

-(void)replaceFileWrapper:(NSFileWrapper*)fileWrapper
{
	NSFileWrapper *ifw = [self.fileWrappers objectForKey:fileWrapper.preferredFilename];
	if (ifw)
		[self removeFileWrapper:ifw];
	[self addFileWrapper:fileWrapper];
}

-(void)replaceRegularFileWithContents:(NSData *)data preferredFilename:(NSString *)filename
{
	NSFileWrapper *ifw = [self.fileWrappers objectForKey:filename];
	if (ifw)
		[self removeFileWrapper:ifw];
	[self addRegularFileWithContents:data preferredFilename:filename];
}

-(void)replaceRegularFileWithUTF8String:(NSString *)string preferredFilename:(NSString *)filename
{
	[self replaceRegularFileWithContents:[string dataUsingEncoding:NSUTF8StringEncoding] preferredFilename:filename];
}
@end
