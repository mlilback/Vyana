//
//  NSArray+AMExtensions.h
//
//  Created by Mark Lilback on Tue Oct 28 2003.
//  Copyright (c) 2003-2011 Agile Monks, LLC. All rights reserved.
//
//	Compatibility: Mac OS X: 10.6, iPhone: 4.1
//

#import <Foundation/Foundation.h>


@interface NSArray (AMExtensions)
//adds object count times
+(id)arrayWithObject:(id)object count:(NSInteger)count;
//finds an index based on comparing value with value returned by sel 
// on each object in the array. returns -1 if no match found.
-(NSInteger)indexOfObjectWithValue:(id)value usingSelector:(SEL)sel;
//returns -1 if not found, otherwise the best possible match
// for string out of the strings in self
-(NSInteger)indexOfBestStringMatch:(NSString*)string;

//returns the first object in the array. if there are no objects, returns nil.
// this lets you avoid the exception when callling objectAtIndex: 0 on an empty array.
-(id)firstObject;

-(id)firstObjectWithValue:(id)value forKey:(NSString*)key;

-(BOOL)containsObject:(id)object withKeyPath:(NSString*)key;
-(BOOL)containsObjectWithValue:(id)value forKey:(NSString*)key;

-(id)randomObject;

//returns count of items matching item
-(NSInteger)countOfItem:(id)item;

-(BOOL)allObjectsRespondToSelector:(SEL)sel;
//returns YES if all objects respond YES to selector (which should take
// no arguments and return a BOOL value)
-(BOOL)allObjectsRespondYes:(SEL)sel;

//If any item conforms to NSMutableCopying, -mutableCopy is called.
// else, if conforms to NSCopying, -copy is called.
// otherwise, same item is placed in new array
-(NSArray*)deepCopy;

-(NSArray *)arrayByPerformingSelector:(SEL)aSelector;
-(NSArray *)arrayByPerformingSelector:(SEL)aSelector withObject:(id)anObject;

-(NSArray*)arrayByRemovingObjectAtIndex:(NSInteger)idx;

-(NSArray*)subarrayFromIndex:(NSInteger)index;

-(BOOL)containsObjectIdenticalTo:(id)object;
-(BOOL)containsAnyObjectsIdenticalTo:(NSArray*)objects;
-(NSIndexSet*)indexesOfObjects:(NSArray*)objects;

@end

@interface NSMutableArray (AMExtensions)
-(void)shuffleArray;
-(void)reverse;
-(void)moveItemAtIndex:(NSInteger)srcIndex toIndex:(NSInteger)destIndex;
-(BOOL)addUniqueObject:(id)anObject;
@end
