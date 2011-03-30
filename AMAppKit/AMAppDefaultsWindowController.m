//
//  AMAppDefaultsWindowController.m
//  Vyana
//
//  Created by Mark Lilback on 3/29/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import "AMAppDefaultsWindowController.h"
#import "AMAppDefaults.h"
#import "AMDefaultsSet.h"

static int ddLogLevel = LOG_LEVEL_INFO;

@implementation AMAppDefaultsWindowController
+ (int)ddLogLevel
{
	return ddLogLevel;
}

+ (void)ddSetLogLevel:(int)logLevel
{
	ddLogLevel = logLevel;
}

-(id)init
{
	self = [super initWithWindowNibName:@"AMAppDefaultsWindowController"];
	return self;
}

-(void)dealloc
{
	self.logLevelNames=nil;
	self.logLevelValues=nil;
	self.logLevelNames2Ids=nil;
	self.logLevels2Names=nil;
	self.logClassNames=nil;
	[super dealloc];
}

-(void)windowDidLoad
{
	NSArray *classNames = [DDLog registeredClassNames];
	AMDefaultsSet *defSet = [[AMAppDefaults sharedInstance] defaultsSetNamed:@"LogLevels"];
	NSMutableArray *names = [NSMutableArray array];
	NSMutableArray *ids = [NSMutableArray array];
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	NSMutableDictionary *levels2names = [NSMutableDictionary dictionary];
	for (id aLogFlag in [defSet.allPropertyKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]) {
		NSString *name = [defSet objectForKey:aLogFlag];
		[names addObject:name];
		[ids addObject:aLogFlag];
		[dict setObject:aLogFlag forKey:name];
		[levels2names setObject:name forKey:aLogFlag];
	}
	self.logLevelNames = names;
	self.logLevelValues = ids;
	self.logLevelNames2Ids = dict;
	self.logLevels2Names = levels2names;
	self.logClassNames = [classNames sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	for (int i=0; i < 10; i++) {
		NSTableColumn *col = [self.logTableView tableColumnWithIdentifier:[NSString stringWithFormat:@"%i", i]];
		if (i >= [self.logLevelNames2Ids count]) {
			[self.logTableView removeTableColumn:col];
		} else {
			[[col headerCell] setTitle:[self.logLevelNames objectAtIndex:i]];
			if ([[self.logLevelValues objectAtIndex:i] intValue] == 0)
				[col setEditable:NO];
		}
	}
	[self.logTableView reloadData];
}

#pragma mark - table view

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	return [self.logClassNames count];
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	NSString *classname = [self.logClassNames objectAtIndex:row];
	if ([[tableColumn identifier] isEqualToString:@"name"])
		return classname;
	//must be log level. figureout which one
	int colno = [[tableColumn identifier] intValue];
	int logFlag = [[self.logLevelValues objectAtIndex:colno] intValue];
	int logLevel = [DDLog logLevelForClassWithName:classname];
	if ((0 == logFlag) || (logFlag & logLevel))
		return (id)kCFBooleanTrue;
	return (id)kCFBooleanFalse;
}

-(void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	NSString *classname = [self.logClassNames objectAtIndex:row];
	int colno = [[tableColumn identifier] intValue];
	int logFlag = [[self.logLevelValues objectAtIndex:colno] intValue];
	int logLevel = [DDLog logLevelForClassWithName:classname];
	DDLogInfo(@"changing %@ log level from %i to %i", classname, logLevel, logLevel ^ logFlag);
	logLevel = logLevel ^ logFlag;
	[DDLog setLogLevel:logLevel forClassWithName:classname];
}

@synthesize logLevelNames;
@synthesize logLevelValues;
@synthesize logLevels2Names;
@synthesize logLevelNames2Ids;
@synthesize logClassNames;
@synthesize logTableView;
@end
