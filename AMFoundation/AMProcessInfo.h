//
//  AMProcessInfo.h
//  Vyana
//
//  Created by Mark Lilback on 8/18/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMProcessInfo : NSObject {
}

+(NSArray*)currentProcessList;

@property (nonatomic, retain) NSString *launchPath;
@property (nonatomic, assign) pid_t pid;
@end
