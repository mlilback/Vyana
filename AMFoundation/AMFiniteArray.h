//
//  AMFiniteArray.h
//  Vyana
//
//  Created by Harner Alexander on 10/18/11.
//  Copyright (c) 2011 Agile Monks. All rights reserved.
//

#import <Foundation/Foundation.h>

// This acts like an NSMutableArray, except that the length is capped to countMax,
// such that objects added after count=countMax cause the oldest added objects to
// pop off (first-in, first-out). It also addes a location counter, set to the most
// recently added object, so that previous and next can iterate.
// NOTE: setCountMax can used to increase or decrease our array cap size without
// erasing its data (it does however make a new internal array and resets location). 
@interface AMFiniteArray : NSObject

@property (nonatomic, assign) NSUInteger countMax;	// max length of our array (also capacity)
@property (nonatomic, assign) NSUInteger count;		// current number of objects in our array
@property (nonatomic, assign) NSInteger location;	// moveable cursor in our array
@property (nonatomic, assign) BOOL uniqueObjects;	// add only unique objects

+ (id)arrayWithCapacity:(NSUInteger)numItems;	// count will still be 0...
- (id)initWithCapacity:(NSUInteger)numItems;	// and location=-1 to start

// NSMutableArray methods
- (void)addObject:(id)anObject;	// increases array upto countMax, then pops off oldest objects...
- (void)addObjectsFromArray:(NSArray*)otherArray;	// in a first-in, first-out manner
- (void)removeAllObjects;		// keeps array with a capacity, but count=0, location=-1
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

// NSArray methods
- (BOOL)containsObject:(id)anObject;
- (id)firstObject;	// oldest added object
- (id)lastObject;	// newest added object
- (id)objectAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfObject:(id)anObject;	// isEqual comparison
- (NSUInteger)indexOfObjectIdenticalTo:(id)anObject;	// same memory pointer

// Location methods:
- (id)objectAtLocation;	// current location, not index
- (id)previous;	// decreases location and returns object there
- (id)next;		// increases location and returns object there

@end
