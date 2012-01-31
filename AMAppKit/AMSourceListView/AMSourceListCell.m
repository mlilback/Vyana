//
//  AMSourceListCell.m
//
//  Copyright 2010-11 Agile Monks, LLC . All rights reserved.
//  Based on SourceListView by Mark Alldritt. <http://www.latenightsw.com/blog/>
//
//	Compatibility: Mac OS X: 10.6, iPhone: NA
//

#import "AMSourceListCell.h"
#import "AMSourceListView.h"


@implementation AMSourceListCell

- (id) copyWithZone:(NSZone*) zone
{
	AMSourceListCell* newCell = [super copyWithZone:zone];
	
	[newCell->mValue retain];
	return newCell;
}

- (void) dealloc
{
	[mValue release];
	[super dealloc];
}

- (NSDictionary*) objectValue { return [[mValue retain] autorelease]; }
- (void) setObjectValue:(NSDictionary*) value
{
	if (mValue != value)
	{
		[mValue release];
		mValue = [value retain];
		
		if ([mValue isKindOfClass:[NSDictionary class]])
			[self setStringValue:[mValue objectForKey:@"name"]];
		else
			[super setObjectValue:value];
	}
}

- (NSColor*) highlightColorWithFrame:(NSRect) cellFrame inView:(NSView*) controlView
{
	//	The table view does the highlighting.  Returning nil seems to stop the cell from
	//	attempting th highlight the row.
	return nil;
}

- (void) drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	NSParameterAssert([controlView isKindOfClass:[AMSourceListView class]]);

	if ([self isHighlighted])
	{
		NSFontManager* fontManager = [NSFontManager sharedFontManager];
		NSString* title = [self stringValue];
		NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithDictionary:[[self attributedStringValue] attributesAtIndex:0 effectiveRange:NULL]];
		NSFont* font = [attrs objectForKey:NSFontAttributeName];

		switch ([(AMSourceListView*) controlView appearance])
		{
		default:
		case kSourceList_iTunesAppearance:
			{
				[attrs setValue:[fontManager convertFont:font toHaveTrait:NSBoldFontMask] forKey:NSFontAttributeName];
				[attrs setValue:[NSColor darkGrayColor] forKey:NSForegroundColorAttributeName];

				NSSize titleSize = [title sizeWithAttributes:attrs];
				NSRect inset = cellFrame;
				
				inset.size.height = titleSize.height;
				inset.origin.y = NSMinY(cellFrame) + (NSHeight(cellFrame) - titleSize.height) / 2.0;
				inset.origin.x += 3; // Nasty to hard-code this. Can we get it to draw its own content, or determine correct inset?
				inset.origin.y += 1;

				[title drawInRect:inset withAttributes:attrs];

				inset.origin.y -= 1;
				[attrs setValue:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
				[title drawInRect:inset withAttributes:attrs];
			}
			break;
		
		case kSourceList_NumbersAppearance:
			{
				NSWindow* window = [controlView window];

				if ([window firstResponder] == controlView && 
					[window isMainWindow] &&
					[window isKeyWindow])
				{
					[attrs setValue:[fontManager convertFont:font toHaveTrait:NSBoldFontMask] forKey:NSFontAttributeName];
					[attrs setValue:[NSColor darkGrayColor] forKey:NSForegroundColorAttributeName];

					NSSize titleSize = [title sizeWithAttributes:attrs];
					NSRect inset = cellFrame;
					
					inset.size.height = titleSize.height;
					inset.origin.y = NSMinY(cellFrame) + (NSHeight(cellFrame) - titleSize.height) / 2.0;
					inset.origin.x += 3; // Nasty to hard-code this. Can we get it to draw its own content, or determine correct inset?
					inset.origin.y += 1;

					[title drawInRect:inset withAttributes:attrs];

					inset.origin.y -= 1;
					[attrs setValue:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
					[title drawInRect:inset withAttributes:attrs];
				}
				else
				{
					[attrs setValue:[fontManager convertFont:font toHaveTrait:NSBoldFontMask] forKey:NSFontAttributeName];
					[attrs setValue:[NSColor darkGrayColor] forKey:NSForegroundColorAttributeName];

					NSSize titleSize = [title sizeWithAttributes:attrs];
					NSRect inset = cellFrame;
					
					inset.size.height = titleSize.height;
					inset.origin.y = NSMinY(cellFrame) + (NSHeight(cellFrame) - titleSize.height) / 2.0;
					inset.origin.x += 3; // Nasty to hard-code this. Can we get it to draw its own content, or determine correct inset?
					[title drawInRect:inset withAttributes:attrs];
				}
			}
			break;
		}
	}
	else
		[super drawInteriorWithFrame:cellFrame inView:controlView];
}

@end
