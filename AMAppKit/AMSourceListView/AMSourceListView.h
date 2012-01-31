//
//  AMSourceListView.h
//
//  Copyright 2010-11 Agile Monks, LLC . All rights reserved.
//  Based on SourceListView by Mark Alldritt. <http://www.latenightsw.com/blog/>
//
//	Compatibility: Mac OS X: 10.6, iPhone: NA
//

#import <Cocoa/Cocoa.h>


typedef enum {
	kSourceList_iTunesAppearance,	///< gradient selection backgrounds
	kSourceList_NumbersAppearance	///< flat selection backgrounds
} AppearanceKind;

/** This protocol is used to determine if an item in the outlinew view is
	a source group item. Either the item needs to implement it, or if
	the item is an NSTreeNode, the represented object needs to implement it. 
*/
@protocol AMSourceListViewItem
-(BOOL)isSourceGroupItem;
@end

/** AMSourceListView
	A subclass of NSOutlineView that acts like a source list.
	
	The builtin support for source lists in NSOutlineView was having some
	severe live resizing problems for me, and it didn't draw the same way
	as the Finder and iTunes. So this subclass works better.
	
	The big problem I saw with Mark Alldritt's original code is that the class
	sets itself as its own delegate. This means you can't have a controller
	that acts as the delegate. To solve this, I overrode the delegate methods
	so a subdelgate can be set. The delegate methods implemented by AMSourceListView
	will call through to the subdelegate except in shouldSelectItem an heightOfRowByItem
	where an appropriate result is returned for source group items. All others
	call the subdelegate.
	respondsToSelector: and forwardingTargetForSelector: aer implemented to pass 
	all other unimplemented delegate meethods to the subdelegate.
*/
@interface AMSourceListView : NSOutlineView
{
	AppearanceKind	mAppearance;
	id myDelegate;
}
@property (nonatomic,assign) id<NSOutlineViewDelegate> subDelegate;
- (AppearanceKind) appearance;
- (void) setAppearance:(AppearanceKind) newAppearance;
-(BOOL)isSourceGroupItem:(id)item;

@end
