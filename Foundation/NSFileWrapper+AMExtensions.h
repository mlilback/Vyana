//
//  NSFileWrapper+AMExtensions.h
//  Vyana
//
//  Created by Mark Lilback on 1/10/12.
//  Copyright (c) 2012 Agile Monks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileWrapper (AMExtensions)
/** the same as addFileWrapper, but removes any existing filewrapper with the same preferred name */
-(void)replaceFileWrapper:(NSFileWrapper*)fileWrapper;
/** same as addRegularFileWithContents:preferredFilename: except any existing wrapper with filename is
	first removed. */
-(void)replaceRegularFileWithContents:(NSData *)data preferredFilename:(NSString *)filename;
/** converts the string to NSData and then calls replaceRegularFileWithContents:preferredFilename: */
-(void)replaceRegularFileWithUTF8String:(NSString *)string preferredFilename:(NSString *)filename;
@end
