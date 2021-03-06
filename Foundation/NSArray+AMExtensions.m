//
//  NSArray+AMExtensions.m
//
//  Created by Mark Lilback on Tue Oct 28 2003.
//  Copyright (c) 2003-2011 Agile Monks, LLC. All rights reserved.
//
//	Compatibility: Mac OS X: 10.9, iPhone: 8.0
//

#import "NSArray+AMExtensions.h"


@implementation NSArray (AMExtensions)
//adds object count times
+(id)arrayWithObject:(id)object count:(NSInteger)count
{
	id *oarray = calloc(sizeof(id), count);
	NSInteger i;
	for (i=0; i < count; i++)
		oarray[i] = object;
	id array = [[self class] arrayWithObjects: oarray count: count];
	free(oarray);
	return array;
}

//same as objectAtIndex: except returns nil instead of raising range exceptions
-(id)objectAtIndexNoExceptions:(NSUInteger)index
{
	if ([self count] <= 0 || index >= [self count])
		return nil;
	return self[index];
}

-(BOOL)containsObject:(id)object withKeyPath:(NSString*)key
{
	id value = [object valueForKeyPath:key];
	for (id obj in self) {
		if ([value isEqual:[obj valueForKeyPath:key]])
			return YES;
	}
	return NO;
}

-(BOOL)containsObjectWithValue:(id)value forKey:(NSString*)key
{
	for (id obj in self) {
		if ([value isEqual: [obj valueForKey:key]])
			return YES;
	}
	return NO;
}

-(id)firstObjectWithValue:(id)value forKey:(NSString*)key
{
	for (id obj in self) {
		if ([value isEqual: [obj valueForKey:key]])
			return obj;
	}
	return nil;
}

//returns a random object using arc4random.
-(id)randomObject
{
	if ([self count] < 1)
		return [self lastObject];
	return self[arc4random()%([self count])];
}

//finds an index based on comparing value with value returned by sel 
// on each object in the array. returns -1 if no match found.
-(NSInteger)indexOfObjectWithValue:(id)value usingSelector:(SEL)sel
{
	NSInteger i;
	for (i=0; i < [self count]; i++) {
		if ([value isEqual: [self[i] performSelector: sel]])
			return i;
	}
	return -1;
}

//returns NSNotFound if not found
-(NSUInteger)indexOfFirstObjectWithValue:(id)value forKey:(NSString*)key
{
	NSUInteger i;
	for (i=0; i < [self count]; i++) {
		if ([value isEqual: [self[i] valueForKey:key]])
			return i;
	}
	return NSNotFound;
}

//returns -1 if not found, otherwise the best possible match
// for string out of the strings in self
-(NSInteger)indexOfBestStringMatch:(NSString*)string
{
	NSInteger idx=-1,i,j,cnt;
	//we'll slowly look for matches
	idx = [self indexOfObject: string];
	if (idx != NSNotFound) 
		return idx;//exact match
	cnt = [self count];
	for (i=[string length]; i >= 0; i--) {
		NSString *match = [string substringToIndex: i];
		for (j=0; j < cnt; j++) {
			NSString *s = self[j];
			if (NSNotFound != [s rangeOfString: match 
						options: NSAnchoredSearch | NSCaseInsensitiveSearch].location)
			{
				return j;
			}
		}
	}
	return -1;
}

// If any item conforms to NSMutableCopying, -mutableCopy is called.
// else, if conforms to NSCopying, -copy is called.
// otherwise, same item is placed in new array
-(id)deepCopy
{
	id newArray = [[[NSMutableArray alloc] init] autorelease];
	NSEnumerator *en = [self objectEnumerator];
	id anItem;
	while ((anItem = [en nextObject])) {
		if ([anItem conformsToProtocol: @protocol(NSMutableCopying)])
			[newArray addObject: [[anItem mutableCopy] autorelease]];
		else if ([anItem conformsToProtocol: @protocol(NSCopying)])
			[newArray addObject: [[anItem copy] autorelease]];
		else
			[newArray addObject: anItem];
	}
	if ([self conformsToProtocol:@protocol(NSMutableCopying)])
		return newArray;
	return [NSArray arrayWithArray:newArray];
}

//returns count of items matching item
-(NSInteger)countOfItem:(id)item
{
	NSInteger i,c,tot=0;
	for (i=0,c=[self count]; i < c; i++) {
		if ([item isEqual: self[i]])
			tot++;
	}
	return tot;
}

-(BOOL)allObjectsRespondToSelector:(SEL)sel
{
	NSInteger i,c;
	for (i=0,c=[self count]; i < c; i++) {
		if (![self[i] respondsToSelector: sel])
			return NO;
	}
	return YES;
}

//returns YES if all objects respond YES to selector (which should take
// no arguments and return a BOOL value)
-(BOOL)allObjectsRespondYes:(SEL)sel
{
	NSInteger i,c;
	for (i=0,c=[self count]; i < c; i++) {
		if (0 == [self[i] performSelector: sel])
			return NO;
	}
	return YES;
}

-(NSArray*)subarrayFromIndex:(NSInteger)index
{
	NSRange rng = NSMakeRange(index, [self count] - index);
	return [self subarrayWithRange:rng];
}

-(NSArray *)arrayByPerformingSelector:(SEL)aSelector
{
	// objc_msgSend won't bother passing the nil argument to the method implementation because of the selector signature.
	return [self arrayByPerformingSelector:aSelector withObject:nil];
}

-(NSArray *)arrayByPerformingSelector:(SEL)aSelector withObject:(id)anObject
{
	NSMutableArray *result;
	NSUInteger index, count;

	result = [NSMutableArray arrayWithCapacity:[self count]];
	for (index = 0, count = [self count]; index < count; index++) {
		id singleObject;
		id selectorResult;

		singleObject = self[index];
		selectorResult = [singleObject performSelector:aSelector withObject:anObject];

		if (selectorResult)
			[result addObject:selectorResult];
	}

	return result;	//!! should we return mutable?
}

-(NSArray*)arrayByRemovingObjectAtIndex:(NSInteger)idx
{
	if (idx == 0)
		return [self subarrayWithRange:NSMakeRange(1, [self count]-1)];
	if (idx == [self count]-1)
		return [self subarrayWithRange:NSMakeRange(0, [self count]-1)];
	NSMutableArray *a = [[self mutableCopy] autorelease];
	[a removeObjectAtIndex:idx];
	return [NSArray arrayWithArray:a];
}

-(BOOL)containsObjectIdenticalTo:(id)obj
{ 
	return NSNotFound != [self indexOfObjectIdenticalTo:obj]; 
}

-(BOOL)containsAnyObjectsIdenticalTo:(NSArray*)objects
{
	NSEnumerator *e = [objects objectEnumerator];
	id obj;
	while ((obj = [e nextObject]))
	{
		if ([self containsObjectIdenticalTo:obj])
			return YES;
	}
	return NO;
}

-(NSIndexSet*)indexesOfObjects:(NSArray*)objects
{
	NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
	NSEnumerator *enumerator = [objects objectEnumerator];
	id obj = nil;
	NSInteger index;
	while ((obj = [enumerator nextObject]))
	{
		index = [self indexOfObject:obj];
		if (index != NSNotFound)
			[indexSet addIndex:index];
	}
	return indexSet;
}

-(NSArray*)sortedArrayUsingKey:(NSString*)key ascending:(BOOL)asc
{
	NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:key ascending:asc];
	NSArray *sortDescArray = @[sortDesc];
	return [self sortedArrayUsingDescriptors:sortDescArray];
}

@end

@implementation NSMutableArray (AMExtensions)

-(void)moveItemAtIndex:(NSInteger)srcIndex toIndex:(NSInteger)destIndex
{
	if (srcIndex == destIndex)
		return;
	id item = [[self objectAtIndex:srcIndex] retain];
	[self removeObjectAtIndex:srcIndex];
	if (srcIndex > destIndex)
		[self insertObject:item atIndex:destIndex];
	else
		[self insertObject:item atIndex:destIndex-1];
	[item release];
}

-(void)shuffleArray
{
	NSUInteger count = [self count], it, jt, n;
	if (count < 2) return;
	for (it=0; it<count; it++) {
		n = (arc4random()%(count-1)) + 1;
		for (jt=0; n==it || jt<10; jt++) n = arc4random()%count;
		[self exchangeObjectAtIndex:it withObjectAtIndex:n];
	}
}

-(void)reverse
{
    NSUInteger count, i;

    count = [self count];
    if (count < 2)
        return;
    for(i=0; i < count/2; i++) {
        NSUInteger ri = count - i - 1;
        [self exchangeObjectAtIndex:i withObjectAtIndex:ri];
    }
}

// Only adds unique objects to the array using containsObject's isEqual mesage on each obj:
-(BOOL)addUniqueObject:(id)anObject
{
	if (nil == anObject)
		return NO;	// don't add nil objects
	if ([self containsObject:anObject])
		return NO;	// don't add objects already there
	[self addObject:anObject];
	return YES;
}

// Only adds objects with unique pointers (contents are not compared):
-(BOOL)addUniqueObjectPointer:(id)anObject
{
	if (nil == anObject)
		return NO;	// don't add nil objects
	if (NSNotFound != [self indexOfObjectIdenticalTo:anObject])
		return NO;	// don't add objects already there
	[self addObject:anObject];
	return YES;
}

@end
