//
//  AMAppDefaults.m
//  Vyana
//
//  Created by Mark Lilback on 3/29/11.
//  Copyright 2011 Agile Monks. All rights reserved.
//

#import "AMAppDefaults.h"
#import "AMDefaultsConfigFile.h"
#import "AMDefaultsSet.h"
#import "VyanaPrivate.h"

static int ddLogLevel = LOG_LEVEL_WARN;

@interface AMAppDefaults()
-(id)initPrivate;
-(void)loadDefaults;
-(void)loadBundles:(NSArray*)bundles;
-(void)loadBundle:(NSBundle*)bundle;
@property (nonatomic, retain) NSMutableArray *configFiles;
@property (nonatomic, readwrite, copy) NSDictionary *propertySets;
@end

@implementation AMAppDefaults
+ (int)ddLogLevel
{
	return ddLogLevel;
}

+ (void)ddSetLogLevel:(int)logLevel
{
	ddLogLevel = logLevel;
}

+ (id)sharedInstance
{
	static dispatch_once_t pred;
	static AMAppDefaults *aMAppDefaults = nil;
	
	dispatch_once(&pred, ^{ aMAppDefaults = [[self alloc] initPrivate]; });
	return aMAppDefaults;
}

-(id)init
{
	[self dealloc];
	[NSException raise:NSGenericException format:@"this class cannot be instantiated"];
	return nil;
}

-(id)initPrivate
{
	if ((self = [super init])) {
		self.configFiles = [NSMutableArray array];
		[self loadDefaults];
	}
	return self;
}

-(void)loadDefaults
{
	[self loadBundle:[NSBundle mainBundle]];
	[self loadBundles:[NSBundle allFrameworks]];
	[self loadBundles:[NSBundle allBundles]];
	//self.configFiles now has all the config files loaded.
	NSMutableDictionary *sets = [NSMutableDictionary dictionary];
	for (AMDefaultsConfigFile *cfile  in [self.configFiles reverseObjectEnumerator]) {
		for (NSDictionary *aDict in [cfile.configDictionary objectForKey:@"PropertySets"]) {
			NSString *setName = [aDict objectForKey:@"Name"];
			AMDefaultsSet *aSet = [sets objectForKey:setName];
			if (nil == aSet) {
				aSet = [[[AMDefaultsSet alloc] init] autorelease];
				[sets setObject:aSet forKey:setName];
				DDLogInfo(@"creating set %@", setName);
			}
			id valObj = [aDict objectForKey:@"Values"];
			if ([valObj isKindOfClass:[NSDictionary class]]) {
				DDLogInfo(@"loading dict values for set %@ from %@", setName, [cfile.bundle bundleIdentifier]);
				[aSet takePropertiesFromDict:aDict];
			} else if ([valObj isKindOfClass:[NSString class]]) {
				DDLogInfo(@"loading plist values for set %@ from %@", setName, [cfile.bundle bundleIdentifier]);
				NSURL *url = [cfile.bundle URLForResource:[valObj stringByDeletingPathExtension] 
											withExtension:[valObj pathExtension]];
				NSDictionary *d = [NSDictionary dictionaryWithContentsOfURL:url];
				[aSet takePropertiesFromDict:d];
			} else {
				DDLogError(@"invalid values for property set %@ in bundle %@", setName, [cfile.bundle bundleIdentifier]);
			}
		}
	}
	self.propertySets = sets;
}

-(void)loadBundles:(NSArray*)bundles
{
	for (NSBundle *aBundle in bundles)
		[self loadBundle:aBundle];
}

-(void)loadBundle:(NSBundle*)bundle
{
	NSURL *url = [bundle URLForResource:@"VyanaConfig" withExtension:@"plist"];
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfURL:url];
	if (nil == dict)
		return;
	DDLogInfo(@"loading config file %@", [bundle bundleIdentifier]);
	AMDefaultsConfigFile *cfg = [[AMDefaultsConfigFile alloc] initWithDictionary:dict bundle:bundle];
	[self.configFiles addObject:cfg];
	[cfg release];
}

-(AMDefaultsSet*)defaultsSetNamed:(NSString*)aSetName
{
	return [self.propertySets objectForKey:aSetName];
}

@synthesize propertySets;
@synthesize configFiles;
@end
