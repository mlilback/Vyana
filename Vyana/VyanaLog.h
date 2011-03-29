//
//  VyanaLog.h
//
//  Created by Mark Lilback on 3/29/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//


//This defines log levels used in Vyana and other Agile Monks frameworks.

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
