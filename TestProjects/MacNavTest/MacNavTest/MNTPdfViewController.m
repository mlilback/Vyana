//
//  MNTPdfViewController.m
//  MacNavTest
//
//  Created by Mark Lilback on 11/16/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import "MNTPdfViewController.h"

@implementation MNTPdfViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if ((self = [super initWithNibName:@"MNTPdfViewController" bundle:nil])) {
	}
	
	return self;
}

-(void)awakeFromNib
{
	PDFDocument *doc = [[PDFDocument alloc] initWithURL:[NSURL fileURLWithPath:self.filePath]];
	self.pdfView.document = doc;
}

@synthesize pdfView;
@synthesize filePath;
@end
