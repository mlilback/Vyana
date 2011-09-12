//
//  CALayer+LayerDebugging.m
//  Vyana
//
//  Created by Mark Lilback on 9/7/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import "CALayer+LayerDebugging.h"

@implementation CALayer (LayerDebugging)
-(CALayer*)firstSublayerWithName:(NSString*)name
{
	for (CALayer *layer in self.sublayers) {
		if ([name isEqualToString:layer.name])
			return layer;
		CALayer *child = [layer firstSublayerWithName:name];
		if (child)
			return child;
	}
	return nil;
}

-(NSString*)debugDescription
{
#if (__MAC_OS_X_VERSION_MIN_REQUIRED >= 1060)
	NSString *frame = NSStringFromRect(NSRectFromCGRect(self.frame));
#else
	NSString *frame = NSStringFromCGRect(self.frame);
#endif
	return [NSString stringWithFormat:@"<%@ (%@) frame=%@ zAnchor=%1.1f>", NSStringFromClass([self class]),
			self.name, frame, self.zPosition];
}

-(void)debugAppendToLayerTree:(NSMutableString*)treeStr indention:(NSString*)indentStr
{
	[treeStr appendFormat:@"%@%@\n", indentStr, self.debugDescription];
	for (CALayer *aSub in self.sublayers)
		[aSub debugAppendToLayerTree:treeStr indention:[indentStr stringByAppendingString:@"\t"]];
}

-(NSString*)debugLayerTree
{
	NSMutableString *str = [NSMutableString string];
	[self debugAppendToLayerTree:str indention:@""];
	return str;
}

@end
