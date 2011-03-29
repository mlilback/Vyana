//
//  NSFont+AMExtensions.m
//
//  Created by Mark Lilback on 3/1/11.
//  Copyright 2011 Agile Monks, LLC. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: NA
//

#import "NSFont+AMExtensions.h"


@implementation NSFont(AMExtensions)
-(NSFont*)italicVersion
{
	NSFont *theFont=self;
	NSFontManager *sharedFontManager = [NSFontManager sharedFontManager];

	theFont = [sharedFontManager convertFont:theFont toHaveTrait:NSItalicFontMask];

	NSFontTraitMask fontTraits = [sharedFontManager traitsOfFont:theFont];

	if ( !( (fontTraits & NSItalicFontMask) == NSItalicFontMask ) ) {
		const CGFloat kRotationForItalicText = -14.0;

		NSAffineTransform *fontTransform = [NSAffineTransform transform];           

		[fontTransform scaleBy:[NSFont systemFontSizeForControlSize:NSMiniControlSize]];

		NSAffineTransformStruct italicTransformData;

		italicTransformData.m11 = 1;
		italicTransformData.m12 = 0;
		italicTransformData.m21 = -tanf( kRotationForItalicText * acosf(0) / 90 );
		italicTransformData.m22 = 1;
		italicTransformData.tX  = 0;
		italicTransformData.tY  = 0;

		NSAffineTransform   *italicTransform = [NSAffineTransform transform];

		[italicTransform setTransformStruct:italicTransformData];

		[fontTransform appendTransform:italicTransform];

		theFont = [NSFont fontWithDescriptor:[theFont fontDescriptor] textTransform:fontTransform];
	}
	return theFont;
}
@end
