//
//  NSManagedObjectContext+AMExtensions.m
//
//  Created by Mark Lilback on 9/11/2009.
//  Copyright 2009-2011 Agile Monks, LLC. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "NSManagedObjectContext+AMExtensions.h"
#import "NSArray+AMExtensions.h"

@implementation NSManagedObjectContext (AMExtensions)

-(BOOL)saveWithErrorLogging:(NSError**)outError
{
	NSError *err=nil;
	BOOL success = [self save:&err];
	if (!success) {
		if (outError)
			*outError = err;
		NSLog(@"Failed to save to data store: %@", [err localizedDescription]);
		NSArray *errors = [[err userInfo] objectForKey:NSDetailedErrorsKey];
		if (IsEmpty(errors)) {
			NSLog(@"info: %@", [err userInfo]);
		} else {
			for (err in errors)
				NSLog(@"Detailed Error: %@", [err userInfo]);
		}
	}
	return success;
}

-(NSManagedObject*)firstObjectFromFetchRequestNamed:(NSString*)reqName parameters:(NSDictionary*)params
{
	NSManagedObjectModel *mom = [[self persistentStoreCoordinator] managedObjectModel];
	NSFetchRequest *req = [mom fetchRequestFromTemplateWithName:reqName substitutionVariables:params];
	NSError *err=nil;
	NSArray *matches = [self executeFetchRequest:req error:&err];
	if (err)
		NSLog(@"error in firstObjectFromFetchRequestNamed:parameters: : %@", [err localizedDescription]);
	if ([matches count] > 0)
		return [matches firstObject];
	return nil;
}

//when using multiple configurations, countForFetcRequest fails unless 
// setAffectedStores is set on the fetch request. This convience method
// returns a fetch request with affectedStores set to the appropriate store
- (NSFetchRequest*)fetchRequestForConfiguration:(NSString*)configName
{
	NSFetchRequest *fr = [[[NSFetchRequest alloc] init] autorelease];
	NSArray *stores = [[self persistentStoreCoordinator] persistentStores];
	[fr setAffectedStores: [NSArray arrayWithObject:
		[stores firstObjectWithValue:configName forKey:@"configurationName"]]];
	return fr;
}

- (NSManagedObject *)objectWithURI:(NSURL *)uri
{
	NSManagedObjectID *objectID =
		[[self persistentStoreCoordinator]
			managedObjectIDForURIRepresentation:uri];
	
	if (!objectID)
	{
		return nil;
	}
	
	NSManagedObject *objectForID = [self objectWithID:objectID];
	if (![objectForID isFault])
	{
		return objectForID;
	}

	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:[objectID entity]];
	
	// Equivalent to
	// predicate = [NSPredicate predicateWithFormat:@"SELF = %@", objectForID];
	NSPredicate *predicate =
		[NSComparisonPredicate
			predicateWithLeftExpression:
				[NSExpression expressionForEvaluatedObject]
			rightExpression:
				[NSExpression expressionForConstantValue:objectForID]
			modifier:NSDirectPredicateModifier
			type:NSEqualToPredicateOperatorType
			options:0];
	[request setPredicate:predicate];

	NSArray *results = [self executeFetchRequest:request error:nil];
	if ([results count] > 0 )
	{
		return [results objectAtIndex:0];
	}

	return nil;
}
// Convenience method to fetch the array of objects for a given Entity
// name in the context, optionally limiting by a predicate or by a predicate
// made from a format NSString and variable arguments.
//
- (NSSet *)fetchObjectsForEntityName:(NSString *)newEntityName
	withPredicate:(id)stringOrPredicate, ...
{
	NSArray *a = nil;
	va_list variadicArguments;
	va_start(variadicArguments, stringOrPredicate);
	a = [self fetchObjectsArrayForEntityName:newEntityName withPredicate:stringOrPredicate
		arguments: variadicArguments];
	va_end(variadicArguments);
	return [NSSet setWithArray:a];
}

- (NSArray *)fetchObjectsArrayForEntityName:(NSString *)newEntityName
	withPredicate:(id)stringOrPredicate, ...
{
	NSArray *a = nil;
	va_list variadicArguments;
	va_start(variadicArguments, stringOrPredicate);
	a = [self fetchObjectsArrayForEntityName:newEntityName withPredicate:stringOrPredicate
		arguments: variadicArguments];
	va_end(variadicArguments);
	return a;
}

- (NSArray *)fetchObjectsArrayForEntityName:(NSString *)newEntityName
	withPredicate:(id)stringOrPredicate arguments:(va_list)arguments
{
	NSEntityDescription *entity = [NSEntityDescription
		entityForName:newEntityName inManagedObjectContext:self];

	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:entity];
	
	if (stringOrPredicate)
	{
		NSPredicate *predicate;
		if ([stringOrPredicate isKindOfClass:[NSString class]])
		{
			predicate = [NSPredicate predicateWithFormat:stringOrPredicate
				arguments:arguments];
		}
		else
		{
			NSAssert2([stringOrPredicate isKindOfClass:[NSPredicate class]],
				@"Second parameter passed to %s is of unexpected class %@",
				sel_getName(_cmd), NSStringFromClass([stringOrPredicate class]));
			predicate = (NSPredicate *)stringOrPredicate;
		}
		[request setPredicate:predicate];
	}
	 
	NSError *error = nil;
	NSArray *results = [self executeFetchRequest:request error:&error];
	if (error != nil)
	{
		[NSException raise:NSGenericException format: @"%@", [error description]];
	}
	
	return results;
}

- (NSArray *)fetchObjectsForEntityName:(NSString *)newEntityName
	withPredicate:(NSPredicate*)predicate sortKey:(NSString*)sortKey
{
	NSEntityDescription *entity = [NSEntityDescription
		entityForName:newEntityName inManagedObjectContext:self];

	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:entity];
	if (predicate)
		[request setPredicate:predicate];
	if (sortKey) {
		NSArray *sortDescriptors = [NSArray 
			arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:sortKey ascending:YES]];
		[request setSortDescriptors:sortDescriptors];
	}
	 
	NSError *error = nil;
	NSArray *results = [self executeFetchRequest:request error:&error];
	if (error != nil)
	{
		[NSException raise:NSGenericException format: @"%@", [error description]];
	}
	
	return results;
}

-(NSInteger)countForEntityName:(NSString*)name withPredicate:(id)stringOrPredicate, ...
{
	NSInteger cnt=0;
	va_list variadicArguments;
	va_start(variadicArguments, stringOrPredicate);
	cnt = [self countForEntityName:name withPredicate:stringOrPredicate
						 arguments: variadicArguments];
	va_end(variadicArguments);
	return cnt;
}

-(NSInteger)countForEntityName:(NSString*)name withPredicate:(id)stringOrPredicate 
					 arguments:(va_list)arguments
{
	NSFetchRequest *fr = [[[NSFetchRequest alloc] init] autorelease];
	[fr setEntity:[NSEntityDescription entityForName:name inManagedObjectContext:self]];

	if (stringOrPredicate)
	{
		NSPredicate *predicate;
		if ([stringOrPredicate isKindOfClass:[NSString class]])
		{
			predicate = [NSPredicate predicateWithFormat:stringOrPredicate
											   arguments:arguments];
		}
		else
		{
			NSAssert2([stringOrPredicate isKindOfClass:[NSPredicate class]],
					  @"Second parameter passed to %s is of unexpected class %@",
					  sel_getName(_cmd), NSStringFromClass([stringOrPredicate class]));
			predicate = (NSPredicate *)stringOrPredicate;
		}
		[fr setPredicate:predicate];
	}

	NSInteger icount = [self countForFetchRequest:fr error:nil];
	return icount;
}

@end
