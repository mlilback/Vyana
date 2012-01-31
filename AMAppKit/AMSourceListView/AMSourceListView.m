//
//  AMSourceListView.m
//
//  Copyright 2010 Agile Monks, LLC . All rights reserved.
//  Based on SourceListView by Mark Alldritt. <http://www.latenightsw.com/blog/>
//

#import "AMSourceListView.h"
#import "AMSourceListCell.h"
#import <objc/runtime.h>

@interface AMSourceListView()
@property (nonatomic, retain) NSImage *blueHighlight;
@property (nonatomic, retain) NSImage *greyHighlight;
@end

@implementation AMSourceListView
@synthesize subDelegate=myDelegate;
@synthesize blueHighlight;
@synthesize greyHighlight;

-(void)dealloc
{
	self.blueHighlight=nil;
	self.greyHighlight=nil;
	[super dealloc];
}

- (void) awakeFromNib
{
	[super setDelegate:(id)self];
	NSBundle *myBundle = [NSBundle bundleForClass:[self class]];
	NSURL *url = [myBundle URLForResource:@"highlight_blue" withExtension:@"tiff"];
	self.blueHighlight = [[[NSImage alloc] initByReferencingURL:url] autorelease];
	url = [myBundle URLForResource:@"highlight_grey" withExtension:@"tiff"];
	self.greyHighlight = [[[NSImage alloc] initByReferencingURL:url] autorelease];
}

-(void)setSubDelegate:(id <NSOutlineViewDelegate>)del
{
	myDelegate=del;
	[super setDelegate:nil];
	[super setDelegate:(id)self];
}

- (BOOL)ourDelegateRespondsToSelector:(SEL)aSelector
{
	//we need to see if the delegate implements the method
	Method delMeth = class_getInstanceMethod([myDelegate class], aSelector);
	Method ourMethd = class_getInstanceMethod([AMSourceListView class], aSelector);
	//if they are not equal, then the delegate implements
	if (delMeth == nil)
		return NO;
	return delMeth != ourMethd;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
	if ([super respondsToSelector:aSelector])
		return YES;
	if ([NSStringFromSelector(aSelector) hasPrefix:@"outlineView"])
		return [myDelegate respondsToSelector:aSelector];
	return NO;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
	if (myDelegate) {
		//we need to see if the delegate implements the method.
		//this should only happen if delegate is a subclass
		Method delMeth = class_getInstanceMethod([myDelegate class], aSelector);
		Method ourMethd = class_getInstanceMethod([AMSourceListView class], aSelector);
		//if they are not equal, then the delegate implements
		if (delMeth != ourMethd)
			return myDelegate;
	}
	return [super forwardingTargetForSelector:aSelector];
}

-(BOOL)isSourceGroupItem:(id)item
{
	if ([item respondsToSelector:@selector(isSourceGroupItem)])
		return [item isSourceGroupItem];
	if ([item respondsToSelector:@selector(representedObject)] &&
			[[item representedObject] respondsToSelector:@selector(isSourceGroupItem)])
	{
		return [[item representedObject] isSourceGroupItem];
	}
	return NO;
}

//	Delegate method
- (BOOL) outlineView:(NSOutlineView*) outlineView shouldSelectItem:(id) item
{
	//	Don't allow the user to select Source Groups
	if ([self isSourceGroupItem:item])
		return NO;
	else if ([self ourDelegateRespondsToSelector:@selector(outlineView:shouldSelectItem:)])
		return [myDelegate outlineView: outlineView shouldSelectItem: item];
	return YES;
}

- (CGFloat) outlineView:(NSOutlineView*) outlineView heightOfRowByItem:(id)item
{
	//	Make the height of Source Group items a little higher
	if ([self isSourceGroupItem:item])
		return [self rowHeight] + 4.0;
	if ([self ourDelegateRespondsToSelector:@selector(outlineView:heightOfRowByItem:)])
		return [myDelegate outlineView:outlineView heightOfRowByItem:item];
	return [self rowHeight];
}

- (AppearanceKind) appearance { return mAppearance; }
- (void) setAppearance:(AppearanceKind) newAppearance
{
	if (mAppearance != newAppearance)
	{
		mAppearance = newAppearance;
		[self setNeedsDisplay:YES];
	}
}

- (void) outlineViewSelectionDidChange:(NSNotification*) notification
{
	if (mAppearance == kSourceList_NumbersAppearance && [[self selectedRowIndexes] count] > 1)
		[self setNeedsDisplay:YES];
	if ([self ourDelegateRespondsToSelector:@selector(outlineViewSelectionDidChange:)])
		[myDelegate outlineViewSelectionDidChange:notification];
}

- (void) outlineViewSelectionIsChanging:(NSNotification*) notification
{
	if (mAppearance == kSourceList_NumbersAppearance && [[self selectedRowIndexes] count] > 1)
		[self setNeedsDisplay:YES];
	if ([self ourDelegateRespondsToSelector:@selector(outlineViewSelectionIsChanging:)])
		[myDelegate outlineViewSelectionIsChanging:notification];
}

- (void) highlightSelectionInClipRect:(NSRect)clipRect
{
	switch (mAppearance)
	{
	default:
	case kSourceList_iTunesAppearance:
		{
			//	This code is cribbed from iTableTextCell.... and draws the highlight for the selected
			//	cell.

			NSRange rows = [self rowsInRect:clipRect];
			NSUInteger maxRow = NSMaxRange(rows);
			NSUInteger row;
			NSImage *gradient;
			/* Determine whether we should draw a blue or grey gradient. */
			/* We will automatically redraw when our parent view loses/gains focus, 
				or when our parent window loses/gains main/key status. */
			if (([[self window] firstResponder] == self) && 
					[[self window] isMainWindow] &&
					[[self window] isKeyWindow]) {
				gradient = self.blueHighlight;
			} else {
				gradient = self.greyHighlight;
			}
			NSAssert(gradient, @"failed to load gradient image");

			/* Make sure we draw the gradient the correct way up. */
			[gradient setFlipped:YES];
			
			for (row = rows.location; row < maxRow; ++row)
			{
				if ([self isRowSelected:row])
				{
					NSRect selectRect = [self rectOfRow:row];

					if (NSIntersectsRect(selectRect, clipRect))
					{
						int i = 0;
						
						/* We're selected, so draw the gradient background. */
						NSSize gradientSize = [gradient size];
						for (i = selectRect.origin.x; i < (selectRect.origin.x + selectRect.size.width); i += gradientSize.width) {
							[gradient drawInRect:NSMakeRect(i, selectRect.origin.y, gradientSize.width, selectRect.size.height)
									fromRect:NSMakeRect(0, 0, gradientSize.width, gradientSize.height)
								   operation:NSCompositeSourceOver
									fraction:1.0];
						}
					}
				}
			}
		}
		break;

	case kSourceList_NumbersAppearance:
		{
			NSRange rows = [self rowsInRect:clipRect];
			NSUInteger maxRow = NSMaxRange(rows);
			NSUInteger row, lastSelectedRow = NSNotFound;
			NSColor* highlightColor = nil;
			NSColor* highlightFrameColor = nil;

			if ([[self window] firstResponder] == self && 
				[[self window] isMainWindow] &&
				[[self window] isKeyWindow])
			{
				highlightColor = [NSColor colorWithCalibratedRed:98.0 / 256.0 green:120.0 / 256.0 blue:156.0 / 256.0 alpha:1.0];
				highlightFrameColor = [NSColor colorWithCalibratedRed:83.0 / 256.0 green:103.0 / 256.0 blue:139.0 / 256.0 alpha:1.0];
			}
			else
			{
				highlightColor = [NSColor colorWithCalibratedRed:160.0 / 256.0 green:160.0 / 256.0 blue:160.0 / 256.0 alpha:1.0];
				highlightFrameColor = [NSColor colorWithCalibratedRed:150.0 / 256.0 green:150.0 / 256.0 blue:150.0 / 256.0 alpha:1.0];
			}

			for (row = rows.location; row < maxRow; ++row)
			{
				if (lastSelectedRow != NSNotFound && row != lastSelectedRow + 1)
				{
					NSRect selectRect = [self rectOfRow:lastSelectedRow];
					
					[highlightFrameColor set];
					selectRect.origin.y += NSHeight(selectRect) - 1.0;
					selectRect.size.height = 1.0;
					NSRectFill(selectRect);
					lastSelectedRow = NSNotFound;
				}
				
				if ([self isRowSelected:row])
				{
					NSRect selectRect = [self rectOfRow:row];

					if (NSIntersectsRect(selectRect, clipRect))
					{
						[highlightColor set];
						NSRectFill(selectRect);
						
						if (row != lastSelectedRow + 1)
						{
							selectRect.size.height = 1.0;
							[highlightFrameColor set];
							NSRectFill(selectRect);
						}
					}

					lastSelectedRow = row;
				}
			}

			if (lastSelectedRow != NSNotFound)
			{
				NSRect selectRect = [self rectOfRow:lastSelectedRow];
				
				[highlightFrameColor set];
				selectRect.origin.y += NSHeight(selectRect) - 1.0;
				selectRect.size.height = 1.0;
				NSRectFill(selectRect);
			}
		}
		break;
	}
}

@end
