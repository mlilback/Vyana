//
//  AMBackgroundTask.h
//  Rc2Engine
//
//  Created by Mark Lilback on 8/16/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

@protocol AMBackgroundDelegate;

@interface AMBackgroundTask : NSObject {}
@property (nonatomic, assign) id<AMBackgroundDelegate> delegate;

-(id)initWithCommand:(NSString*)command arguments:(NSArray*)args workingDir:(NSString*)workingDir;

-(BOOL)taskIsRunning;
-(void)startTask;
-(void)startTaskWithInput:(NSData*)input;
-(void)endTask;
-(void)waitUntilExit;
-(int)processIdentifier;
@end

@protocol AMBackgroundDelegate <NSObject>
-(void)backgroundTask:(AMBackgroundTask*)task sentOutputData:(NSData*)data;
-(void)backgroundTask:(AMBackgroundTask*)task sentErrorData:(NSData*)data;
@optional
//-(void)taskStarted:(AMBackgroundTask*)task;
//-(void)taskEnded:(AMBackgroundTask*)task;
@end

//sets itself as its own delegate to catch the output
@interface AMOneShotTask : AMBackgroundTask<AMBackgroundDelegate> {}
-(void)executeTaskWithHandler:(void (^)(int termStatus, NSData *output))hbock;
@end
