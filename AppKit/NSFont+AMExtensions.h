//
//  NSFont+AMExtensions.h
//
//  Created by Mark Lilback on 3/1/11.
//  Copyright 2011 Agile Monks, LLC. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: NA
//


@interface NSFont(AMExtensions)
///Returns an italic variant. If the font doesn't have an italic variant, creates a transform that skews it in the same manner as WebKit
-(NSFont*)italicVersion;
@end
