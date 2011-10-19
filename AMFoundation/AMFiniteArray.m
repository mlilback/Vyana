//
//  AMFiniteArray.m
//  Vyana
//
//  Created by Harner Alexander on 10/18/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import "AMFiniteArray.h"

@interface AMFiniteArray()
@property (nonatomic, assign) NSInteger ind0;
@property (nonatomic, retain) NSMutableArray *array;
@end

@implementation AMFiniteArray

@synthesize countMax=max_;
@synthesize location=loc_;
@synthesize uniqueObjects=uni_;

@synthesize ind0=ind0_;
@synthesize array=array_;

#pragma mark -
#pragma mark init/dealloc
+ (id)arrayWithCapacity:(NSUInteger)numItems {
	return [[[AMFiniteArray alloc] initWithCapacity:numItems] autorelease];
}

- (id)initWithCapacity:(NSUInteger)numItems {
	max_ = numItems;
	uni_ = NO;
	ind0_ = 0;
	loc_ = -1;	// nowhere to begin with
	self.array = [NSMutableArray arrayWithCapacity:numItems];
	return self;
}

- (void)dealloc {
	[array_ release]; array_=nil;
	[super dealloc];
}

#pragma mark -
#pragma mark NSMutableArray methods
// Changes loc:
- (void)addObject:(id)anObject {
	if (!anObject) return;
	if (uni_ && [array_ containsObject:anObject]) {
		return;
	}
	if ([array_ count] < max_) {
		[array_ addObject:anObject];
		loc_ = [array_ count]-1;
	}
	else {
		[array_ replaceObjectAtIndex:ind0_ withObject:anObject];
		ind0_ = (ind0_+1)%max_;
		loc_ = (ind0_-1+max_)%max_;
	}
}

- (void)addObjectsFromArray:(NSArray*)otherArray {
	for (id obj in otherArray) {
		[self addObject:obj];
	}
}

- (void)removeAllObjects {
	[array_ removeAllObjects];
	ind0_ = 0;	loc_ = -1;
}

/*
- (void)removeLastObject {
	ind0_ = (ind0_-1+max_)%max_;
	[array_ replaceObjectAtIndex:ind0_ withObject:[NSNull null]];	
}
*/

// Does not change loc:
/*
- (void)removeObject:(id)anObject {
	NSUInteger ind = [array_ indexOfObject:anObject];
	if (ind == NSNotFound) return;
	[array_ replaceObjectAtIndex:ind withObject:[NSNull null]];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
	NSUInteger ind = (ind0_+index)%max_;
	[array_ replaceObjectAtIndex:ind withObject:[NSNull null]];
}

- (void)removeObjectIdenticalTo:(id)anObject {
	NSUInteger ind = [array_ indexOfObjectIdenticalTo:anObject];
	if (ind == NSNotFound) return;
	[array_ replaceObjectAtIndex:ind withObject:[NSNull null]];
}

- (void)removeObjectsInArray:(NSArray*)otherArray {
	for (id obj in otherArray) {
		[self removeObject:obj];
	}
}
*/

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
	if (!anObject) anObject = [NSNull null];
	NSUInteger ind = (ind0_+index)%max_;
	if (ind >= [array_ count]) {
		//!!! throw an exception
	}
	[array_ replaceObjectAtIndex:ind withObject:anObject];
}

#pragma mark -
#pragma mark NSArray methods

- (BOOL)containsObject:(id)anObject {
	return [array_ containsObject:anObject];
}

- (id)firstObject {
	return [array_ objectAtIndex:ind0_];
}

- (id)lastObject {
	id obj=nil;
	if ([array_ count] < max_) {
		obj = [array_ lastObject];
	}
	else {
		obj = [array_ objectAtIndex:(ind0_-1+max_)%max_];
	}
	return obj;
}

- (id)objectAtIndex:(NSUInteger)index {
	NSUInteger ind = (ind0_+index)%max_;
	if (ind >= [array_ count]) {
		//!!! throw an exception
		return nil;
	}
	return [array_ objectAtIndex:(ind0_+index)%max_];
}

- (NSUInteger)indexOfObject:(id)anObject {
	NSUInteger ind = [array_ indexOfObject:anObject];
	if (ind == NSNotFound) return ind;
	return (ind-ind0_+max_)%max_;
}

- (NSUInteger)indexOfObjectIdenticalTo:(id)anObject {
	NSUInteger ind = [array_ indexOfObjectIdenticalTo:anObject];
	if (ind == NSNotFound) return ind;
	return (ind-ind0_+max_)%max_;
}

#pragma mark -
#pragma mark Location methods

- (id)objectAtLocation {
	return [array_ objectAtIndex:loc_];
}

- (id)previous {
	loc_ = (loc_-1+max_)%max_;
	return [array_ objectAtIndex:loc_];
}

- (id)next {
	loc_ = (loc_+1)%max_;
	return [array_ objectAtIndex:loc_];
}


#pragma mark -
#pragma mark Accessors

- (NSUInteger)count {
	return [array_ count];
}

- (void)setCount:(NSUInteger)count {
	//!!!
}

@end
