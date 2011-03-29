//
//  NSFileHandle+AMExtensions.h
//
//  Created by Mark Lilback on 10/4/2010.
//  Copyright 2010-11 Agile Monks, LLC. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: 4.1
//


@interface NSFileHandle (AMExtensions)
+(id)fileHandleForWritingTemporaryFileWithPrefix:(NSString*)baseFileName filePath:(NSString**)outFilePath;
@end
