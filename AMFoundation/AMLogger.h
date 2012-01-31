//
//  AMLogger.h
//  AgileMonksToolkit
//
//  Created by Mark Lilback on 8/12/2010.
//  Copyright 2010 Agile Monks, LLC. All rights reserved.
//

/** AMLoggerDomains
	
	Constants for what level of log information to debug. They are bit masks
	with the standard ones of Errors, Warnings, and Debug including the previous
	domains. bit masks above AMInternals are not used in the AMToolkit and
	are defined for convience. Flags above that, up to 64 bit can be used.
*/
enum {
	AMLoggerDomain_General=0, 		///<Only logs messages sent without a domain
	AMLoggerDomain_Errors=1, 		///<Logs error messages
	AMLoggerDomain_Warnings=3, 		///<Logs errors and warnings
	AMLoggerDomain_Debug=7, 		///<Logs errors, warning, and debug messages
	AMLoggerDomain_Trace=8,			///<Logs trace messages (very detailed what's going on messages)
	AMLoggerDomain_SQL=16, 			///<Logs SQL queries
	AMLoggerDomain_AMInternals=32, 	///<Logs verbose messages for debugging the AMToolkit
	AMLoggerDomain_AppLevel1=64, 	///<Does not include above flags. Needs to be OR'd with the desired flag above
	AMLoggerDomain_AppLevel2=128, 	///<Does not include above flags. Needs to be OR'd with the desired flag above
	AMLoggerDomain_AppLevel3=256,	 ///<Does not include above flags. Needs to be OR'd with the desired flag above
	AMLoggerDomain_AppLevel4=512	 ///<Does not include above flags. Needs to be OR'd with the desired flag above
	
};
typedef unsigned long AMLoggerDomains;

///constant for NSUserDefaults key used for the file to log to.
extern NSString *AMLoggerLogFileKey;

/** Notifications
	Notifications observers can listen for
*/
extern NSString *AMLoggerErrorNotification; ///<Posted when an error is logged. the object will be the error message
extern NSString *AMLoggerWarningNotification; ///<Posted when a warning is logged. the object will be the warning message

/** AMLogger
	
	Provides a file based logging mechanism.
	When initialized, checks defaults for the key AMLoggerEnabled  to be YES.
	Otherwise, all calls do nothing.
	
	Saves the log to AMLoggerLogFile (defaults to "/tmp/amlogger.log") which can
	be an NSString (path) or NSData (bookmarkData generated by NSURL)
 
 	#define AMLOGGER_ALL_TO_CONSOLE to have all logged messages also sent to NSLog.
*/
@interface AMLogger : NSObject {
	@private
	unsigned long _logDomains;
	NSURL *_logUrl;
	NSFileHandle *_fh;
	NSTimeInterval _flushDelay;
	NSTimer *_timer;
	BOOL _enabled, _echoToConsole;
}
+(AMLogger*)sharedInstance;
@property (assign) BOOL loggingEnabled;
@property (assign) BOOL echoLogToConsole;
@property (retain) NSURL *logfileURL;
///Defaults to AMLoggerDomain_Warnings
@property (assign) unsigned long logDomains;

///seconds the log file is flushed to disk, if dirty. if zero, flushes every
/// time logMessage: is called. Valid values are 0 to 300 (seconds)
@property (assign) NSTimeInterval flushLogFrequency;

//the following log at log level AMLoggerDomainGeneral
-(void)logWithFormat:(NSString*)format, ...;
-(void)logMessage:(NSString*)message;

//the following log at log level AMLoggerDomainErrors
-(void)logErrorWithFormat:(NSString*)format, ...;
-(void)logErrorMessage:(NSString*)message;
//the following log at log level AMLoggerDomainWarnings
-(void)logWarningWithFormat:(NSString*)format, ...;
-(void)logWarningMessage:(NSString*)message;

-(void)logMessageForDomain:(unsigned long)domain format:(NSString*)format, ...;
-(void)logMessage:(NSString*)message forDomain:(unsigned long)domian;

-(void)closeLog;

-(NSString*)descriptionForDomain:(unsigned long)domain;
@end
