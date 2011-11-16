//
//  MNTPdfViewController.h
//  MacNavTest
//
//  Created by Mark Lilback on 11/16/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@interface MNTPdfViewController : NSViewController
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) IBOutlet PDFView *pdfView;
@end
