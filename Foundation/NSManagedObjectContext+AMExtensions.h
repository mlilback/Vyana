//
//  NSManagedObjectContext+AMExtensions.h
//
//  Created by Mark Lilback on 9/11/2009.
//  Copyright 2009-2011 Agile Monks, LLC. All rights reserved.
//


@interface NSManagedObjectContext (AMExtensions)
///when using multiple configurations, countForFetcRequest fails unless 
/// setAffectedStores is set on the fetch request. This convience method
/// returns a fetch request with affectedStores set to the appropriate store
- (NSFetchRequest*)fetchRequestForConfiguration:(NSString*)configurationName;

///calls NSLog to display all nested errors if there was an error saving
-(BOOL)saveWithErrorLogging:(NSError**)outError;

///return the object if found, nil if not found
///from http://cocoawithlove.com/2008/08/safely-fetching-nsmanagedobject-by-uri.html
- (NSManagedObject *)objectWithURI:(NSURL *)uri;
///easily fetch objects with 1 line of code
///from http://cocoawithlove.com/2008/03/core-data-one-line-fetch.html
- (NSSet *)fetchObjectsForEntityName:(NSString *)newEntityName
    withPredicate:(id)stringOrPredicate, ...;
- (NSArray *)fetchObjectsArrayForEntityName:(NSString *)newEntityName
    withPredicate:(id)stringOrPredicate, ...;
- (NSArray *)fetchObjectsArrayForEntityName:(NSString *)newEntityName
    withPredicate:(id)stringOrPredicate arguments:(va_list)arguments;

- (NSArray *)fetchObjectsForEntityName:(NSString *)newEntityName
						 withPredicate:(NSPredicate*)predicate 
							   sortKey:(NSString*)sortKey;

- (NSArray *)fetchObjectsForEntityName:(NSString *)newEntityName
						 withPredicate:(NSPredicate*)predicate 
					   sortDescriptors:(NSArray*)sortDescriptors;

-(NSManagedObject*)firstObjectFromFetchRequestNamed:(NSString*)reqName parameters:(NSDictionary*)params;

- (NSInteger)countForEntityName:(NSString *)newEntityName
							  withPredicate:(id)stringOrPredicate, ...;
- (NSInteger)countForEntityName:(NSString *)newEntityName
							  withPredicate:(id)stringOrPredicate arguments:(va_list)arguments;
@end
