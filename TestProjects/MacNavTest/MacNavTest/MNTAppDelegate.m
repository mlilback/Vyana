//
//  MNTAppDelegate.m
//  MacNavTest
//
//  Created by Mark Lilback on 11/16/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import "MNTAppDelegate.h"
#import <Vyana/NSObject+BlockObservation.h>
#import "MNTPdfViewController.h"

@interface MNTAppDelegate()
@property (nonatomic, strong) NSMutableArray *contentArray;
@property (nonatomic, strong) NSMetadataQuery *fileQuery;
-(void)fileQueryComplete;
@end

@implementation MNTAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	self.navController = [[AMMacNavController alloc] initWithRootViewController:self.rootViewController];
	//load some files into contentArray
	self.contentArray = [NSMutableArray array];
	self.fileQuery = [[NSMetadataQuery alloc] init];
	[self storeNotificationToken:[[NSNotificationCenter defaultCenter] 
								  addObserverForName:NSMetadataQueryDidFinishGatheringNotification 
											  object:self.fileQuery 
											   queue:nil 
										  usingBlock:^(NSNotification *note)
	 {
		 [self fileQueryComplete];
	 }]];
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"kMDItemContentType == 'com.adobe.pdf'"];
	[self.fileQuery setPredicate:pred];
	[self.fileQuery setSearchScopes:[NSArray arrayWithObject:[NSURL fileURLWithPath:
															  [@"~/Dropbox/AgileMonks/Books/" stringByExpandingTildeInPath]]]];
	[self.fileQuery setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:(id)kMDItemDisplayName ascending:YES]]];
	[self.fileQuery startQuery];
}

-(void)fileQueryComplete
{
	[self.fileQuery stopQuery];
	for (NSMetadataItem *mdi in self.fileQuery.results) {
		[self.contentArray addObject:[mdi valueForAttribute:(__bridge NSString*)kMDItemPath]];
	}
	[self.masterTableView reloadData];
}

-(IBAction)back:(id)sender
{
	[self.navController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	return [self.contentArray count];
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	return [[self.contentArray objectAtIndex:row] lastPathComponent];
}

-(void)tableViewSelectionDidChange:(NSNotification *)note
{
	if (self.masterTableView.selectedRow < 0)
		return;
	MNTPdfViewController *vc = [[MNTPdfViewController alloc] init];
	vc.filePath = [self.contentArray objectAtIndex:self.masterTableView.selectedRow];
	[self.navController pushViewController:vc animated:YES];
}

@synthesize window;
@synthesize navController;
@synthesize rootViewController;
@synthesize masterTableView;
@synthesize contentArray;
@synthesize fileQuery;
@end
