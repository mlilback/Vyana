//
//  VyanaLog.h
//
//  Created by Mark Lilback on 3/29/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//


//This defines log levels used in Vyana and other Agile Monks frameworks.
#if (__MAC_OS_X_VERSION_MIN_REQUIRED >= 1060)
#import <Vyana/DDLog.h>
#else
#import "Vyana-ios/DDLog.h"
#endif

//the log level defaults to LOG_LEVEL_WARN. Overridden by the 
// default/command line argument VyanaLogLevel
@interface VyanaLogger : NSObject
+(id)sharedInstance;
@property (nonatomic) NSInteger logLevel;
//removes all loggers and then adds a DDASLLogger and a DDTTYLogger.
//only executes the first time it is called
-(void)startLogging;
//allows other frameworks or objects define their own contexts
-(int)logLevelForKey:(NSString*)key;
-(void)setLogLevel:(int)level forKey:(NSString*)key;
@end

//never read all the options for lumberjack. A custom context works much better
// our constant is hex for "AMVy"
#define VYANA_LOG_CONTEXT 0x79564D41

#define VyanaLogLevel [[VyanaLogger sharedInstance] logLevel]

#define VyanaLogError(frmt, ...)     SYNC_LOG_OBJC_MAYBE(VyanaLogLevel, LOG_FLAG_ERROR,   VYANA_LOG_CONTEXT, frmt, ##__VA_ARGS__)
#define VyanaLogWarn(frmt, ...)     ASYNC_LOG_OBJC_MAYBE(VyanaLogLevel, LOG_FLAG_WARN,    VYANA_LOG_CONTEXT, frmt, ##__VA_ARGS__)
#define VyanaLogInfo(frmt, ...)     ASYNC_LOG_OBJC_MAYBE(VyanaLogLevel, LOG_FLAG_INFO,    VYANA_LOG_CONTEXT, frmt, ##__VA_ARGS__)
#define VyanaLogVerbose(frmt, ...)  ASYNC_LOG_OBJC_MAYBE(VyanaLogLevel, LOG_FLAG_VERBOSE, VYANA_LOG_CONTEXT, frmt, ##__VA_ARGS__)

//with the above, I don't really see a need for the following. treat as deprecated
//not used in Vyana, but might be used in older frameworks

//used for logigng enter/exit of methods
#define LOG_FLAG_TRACE	(1 << 4)
//used in -init and -dealloc methods
#define LOG_FLAG_ALLOC (1 << 5)
//used in SQL frameworks to log SQL calls
#define LOG_FLAG_SQL (1 << 6)

#define LOG_TRACE (ddLogLevel & LOG_FLAG_TRACE)
#define LOG_ALLOC (ddLogLevel & LOG_FLAG_ALLOC)
#define LOG_SQL (ddLogLevel & LOG_FLAG_SQL)

#define DDLogTrace(frmt, ...)   ASYNC_LOG_OBJC_MAYBE(ddLogLevel, LOG_FLAG_TRACE,    0, frmt, ##__VA_ARGS__)
#define DDLogAlloc(frmt, ...)  ASYNC_LOG_OBJC_MAYBE(ddLogLevel, LOG_FLAG_ALLOC,    0, frmt, ##__VA_ARGS__)
#define DDLogSQL(frmt, ...)  ASYNC_LOG_OBJC_MAYBE(ddLogLevel, LOG_FLAG_SQL,    0, frmt, ##__VA_ARGS__)
