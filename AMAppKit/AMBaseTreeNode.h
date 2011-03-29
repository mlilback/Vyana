//
//  AMBaseTreeNode.h
//
//  Created by Mark Lilback on 8/9/2010.
//  Copyright 2010-11 Agile Monks, LLC. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: NA
//

#import <Cocoa/Cocoa.h>

@interface AMBaseTreeNode : NSObject <NSCoding, NSCopying> {
	@private
	id _repObj;
	NSImage			*_nodeIcon;
	NSString		*_nodeTitle;
	NSMutableArray	*_children;
	BOOL			_isLeaf, _isSelectable;
}
@property (nonatomic, copy) NSString *nodeTitle;
@property (nonatomic, assign,getter=isLeaf) BOOL leaf;
@property (nonatomic, assign,getter=isSelectable) BOOL selectable;
@property (nonatomic, retain) NSImage *nodeIcon;
@property (nonatomic, retain) NSArray *children;
@property (nonatomic, retain) id representedObject;

- (id)initLeaf;

- (BOOL)isDraggable;

- (NSComparisonResult)compare:(AMBaseTreeNode *)aNode;

- (NSArray *)mutableKeys;

- (NSDictionary *)dictionaryRepresentation;
- (id)initWithDictionary:(NSDictionary *)dictionary;

- (id)parentFromArray:(NSArray *)array;
- (void)removeObjectFromChildren:(id)obj;
- (NSArray *)descendants;
- (NSArray *)allChildLeafs;
- (NSArray *)groupChildren;
- (BOOL)isDescendantOfOrOneOfNodes:(NSArray *)nodes;
- (BOOL)isDescendantOfNodes:(NSArray *)nodes;
- (NSIndexPath*)indexPathInArray:(NSArray*)array;

@end
