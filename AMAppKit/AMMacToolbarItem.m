//
//  AMMacToolbarItem.m
//  Vyana
//
//  Created by Mark Lilback on 10/14/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import "AMBlockUtils.h"
#import "AMMacToolbarItem.h"
#import "AMCustomDrawImageRep.h"

@interface AMMacToolbarItem() {
	BOOL __didImgResize;
}
@end

@implementation AMMacToolbarItem

-(void)imageSetup
{
	NSImage *timg = self.image;
	__didImgResize = YES;
	if (timg) {
		NSImage *img = [[NSImage alloc] initWithSize:NSMakeSize(24, 24)];
		AMCustomDrawImageRep *imgRep = [[AMCustomDrawImageRep alloc] initWithDrawBlock:^(AMCustomDrawImageRep *rep) {
			NSSize sz = rep.size;
			NSRect r = NSMakeRect(3, 3, sz.width-10, sz.height-10);
			[timg drawInRect:r fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
		}];
		imgRep.size = img.size;
		[img addRepresentation:imgRep];
		[self setImage:img];
	}
}

-(void)awakeFromNib
{
	[super awakeFromNib];
	if (!__didImgResize)
		[self imageSetup];
}

-(void)setImage:(NSImage *)image
{
	[super setImage:image];
	if (!__didImgResize)
		[self imageSetup];
}

@end
