//
//  AMRegExpFormatter.h
//  Vyana
//
//  Created by Mark Lilback on 10/28/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMRegExpFormatter : NSFormatter
@property (nonatomic, strong) NSRegularExpression *regex;
-(id)initWithRegularExpression:(NSRegularExpression*)regex;
-(id)initWithRegularExpressionString:(NSString*)str;
@end
