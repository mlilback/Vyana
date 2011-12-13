//
//  NSArray+AMExtensions.h
//
//  Created by Mark Lilback on Tue Oct 28 2003.
//  Copyright (c) 2003-2011 Agile Monks, LLC. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: 4.1
//

#import <Foundation/Foundation.h>

/** Convience methods on NSArray */
@interface NSArray (AMExtensions)
///adds object count times
+(id)arrayWithObject:(id)object count:(NSInteger)count;
///same as objectAtIndex: except returns nil instead of raising range exceptions
-(id)objectAtIndexNoExceptions:(NSUInteger)index;
///finds an index based on comparing value with value returned by sel 
/// on each object in the array. returns -1 if no match found.
-(NSInteger)indexOfObjectWithValue:(id)value usingSelector:(SEL)sel;
///returns -1 if not found, otherwise the best possible match
/// for string out of the strings in self
-(NSInteger)indexOfBestStringMatch:(NSString*)string;

///returns the first object in the array. if there are no objects, returns nil.
/// this lets you avoid the exception when callling objectAtIndex: 0 on an empty array.
-(id)firstObject;

//finds the first object whose valueForKey: returns value
-(id)firstObjectWithValue:(id)value forKey:(NSString*)key;
//returns NSNotFound if not found
-(NSUInteger)indexOfFirstObjectWithValue:(id)value forKey:(NSString*)key;

-(BOOL)containsObject:(id)object withKeyPath:(NSString*)key;
///@returns YES if the array contains an object whose property key is equal to value
-(BOOL)containsObjectWithValue:(id)value forKey:(NSString*)key;

///@returns a random object from the array
-(id)randomObject;

///returns count of items matching item
-(NSInteger)countOfItem:(id)item;

-(BOOL)allObjectsRespondToSelector:(SEL)sel;
///returns YES if all objects respond YES to selector (which should take
/// no arguments and return a BOOL value)
-(BOOL)allObjectsRespondYes:(SEL)sel;

///If any item conforms to NSMutableCopying, -mutableCopy is called.
/// else, if conforms to NSCopying, -copy is called.
/// otherwise, same item is placed in new array
-(NSArray*)deepCopy;

///@returns array of objects returned by performing aSelector on each object in the array
-(NSArray *)arrayByPerformingSelector:(SEL)aSelector;
///@returns array of objects returned by performing aSelector on each object in the array
-(NSArray *)arrayByPerformingSelector:(SEL)aSelector withObject:(id)anObject;

///@returns a new array containing all elements except the one at idx
-(NSArray*)arrayByRemovingObjectAtIndex:(NSInteger)idx;

///@returns a new array with all objects starting at index
-(NSArray*)subarrayFromIndex:(NSInteger)index;

///@returns YES if any object in the array is identical (pointer-wise) with object
-(BOOL)containsObjectIdenticalTo:(id)object;
///@returns YES if any object in the array is identical (pointer-wise) with an object in objects
-(BOOL)containsAnyObjectsIdenticalTo:(NSArray*)objects;
///@returns an index set containing the indexes of any values in objects that are also in this array
-(NSIndexSet*)indexesOfObjects:(NSArray*)objects;

-(NSArray*)sortedArrayUsingKey:(NSString*)key ascending:(BOOL)asc;

@end

///Convience methods on NSMutableArray
@interface NSMutableArray (AMExtensions)
///shuffles the contents of the array
-(void)shuffleArray;
///reverses the order of objects in the array
-(void)reverse;
///moves an object to a different location
-(void)moveItemAtIndex:(NSInteger)srcIndex toIndex:(NSInteger)destIndex;
///adds anObject only if not already in the array
-(BOOL)addUniqueObject:(id)anObject;
-(BOOL)addUniqueObjectPointer:(id)anObject;
@end
