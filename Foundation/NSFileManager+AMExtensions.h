//
//  NSFileManager+AMExtensions.h
//  Vyana
//
//  Created by Mark Lilback on 8/19/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager(AMExtensions)
//generate a md5 checksum for a file
-(NSString*)md5ForFileAtPath:(NSString*)path;
@end
