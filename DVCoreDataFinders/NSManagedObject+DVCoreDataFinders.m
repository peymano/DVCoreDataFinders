//
//  Created by Peyman Oreizy
//  Copyright 2011 Dynamic Variable LLC. All rights reserved.
//

#import "NSManagedObject+DVCoreDataFinders.h"


@implementation NSManagedObject (DVCoreDataFinders)

#pragma mark - Counters

+ (NSUInteger)countAllInContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr
{
  return [self countAllWithPredicate:nil inContext:context error:errorPtr];
}

+ (NSUInteger)countAllWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr
{
  NSFetchRequest *request = [self fetchRequestWithPredicate:predicate sortedBy:nil ascending:YES inContext:context];

  NSUInteger count = [context countForFetchRequest:request error:errorPtr];

  return count;
}

#pragma mark - Entity helpers

+ (NSEntityDescription *)entityInContext:(NSManagedObjectContext *)context
{
  NSString *entityName = NSStringFromClass(self.class);
  return [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
}

#pragma mark - Finders: find all

+ (NSArray *)findAllInContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr
{
  NSFetchRequest *fetchRequest = [self fetchRequestWithOptions:nil inContext:context];
  return [context executeFetchRequest:fetchRequest error:errorPtr];
}

+ (NSArray *)findAllWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr
{
  NSFetchRequest *request = [self fetchRequestWithPredicate:predicate sortedBy:nil ascending:YES inContext:context];
  return [context executeFetchRequest:request error:errorPtr];
}

+ (NSArray *)findAllWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors options:(NSDictionary *)options inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr
{
  NSFetchRequest *request = [self fetchRequestWithPredicate:predicate sortDescriptors:sortDescriptors options:options inContext:context];
  return [context executeFetchRequest:request error:errorPtr];
}

+ (NSArray *)findAllWithPredicate:(NSPredicate *)predicate sortedBy:(NSString *)sortBy ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr
{
  return [self findAllWithPredicate:predicate sortedBy:sortBy ascending:ascending options:nil inContext:context error:errorPtr];
}

+ (NSArray *)findAllWithPredicate:(NSPredicate *)predicate sortedBy:(NSString *)sortBy ascending:(BOOL)ascending options:(NSDictionary *)options inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr
{
  NSArray *sortDescriptors = nil;

  if (sortBy) {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortBy ascending:ascending];
    sortDescriptors = @[ sortDescriptor ];
  }

  NSFetchRequest *request = [self fetchRequestWithPredicate:predicate sortDescriptors:sortDescriptors options:options inContext:context];
  return [context executeFetchRequest:request error:errorPtr];
}

#pragma mark - Finders: find first

+ (instancetype)findFirstWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr
{
  return [self findFirstWithPredicate:predicate options:nil inContext:context error:errorPtr];
}

+ (instancetype)findFirstWithPredicate:(NSPredicate *)predicate options:(NSDictionary *)options inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr
{
  NSArray *results = [self findAllWithPredicate:predicate sortedBy:nil ascending:YES options:options inContext:context error:errorPtr];

  if (results == nil || results.count == 0) {
    return nil;
  }

  return results[0];
}

+ (instancetype)findFirstWhereProperty:(NSString *)propertyKey equals:(id)value inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr
{
  return [self findFirstWhereProperty:propertyKey equals:value options:nil inContext:context error:errorPtr];
}

+ (instancetype)findFirstWhereProperty:(NSString *)propertyKey equals:(id)value options:(NSDictionary *)options inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", propertyKey, value];
  return [self findFirstWithPredicate:predicate options:options inContext:context error:errorPtr];
}

#pragma mark - NSFetchRequest helpers

+ (NSFetchRequest *)fetchRequestInContext:(NSManagedObjectContext *)context
{
  return [self fetchRequestWithOptions:nil inContext:context];
}

+ (NSFetchRequest *)fetchRequestWithOptions:(NSDictionary *)options inContext:(NSManagedObjectContext *)context
{
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass(self.class)];

  if (options == nil) {
    return fetchRequest;
  }

  id value;

  if ((value = options[@"fetchBatchSize"])) {
    fetchRequest.fetchBatchSize = [value unsignedIntegerValue];
  }

  if ((value = options[@"fetchLimit"])) {
    fetchRequest.fetchLimit = [value unsignedIntegerValue];
  }

  if ((value = options[@"fetchOffset"])) {
    fetchRequest.fetchOffset = [value unsignedIntegerValue];
  }

  if ((value = options[@"includesPendingChanges"])) {
    fetchRequest.includesPendingChanges = [value boolValue];
  }

  if ((value = options[@"includesPropertyValues"])) {
    fetchRequest.includesPropertyValues = [value boolValue];
  }

  if ((value = options[@"propertiesToFetch"])) {
    fetchRequest.propertiesToFetch = value;
  }

  if ((value = options[@"returnsDistinctResults"])) {
    fetchRequest.returnsDistinctResults = [value boolValue];
  }

  if ((value = options[@"resultType"])) {
    fetchRequest.resultType = [value unsignedIntegerValue];
  }

  if ((value = options[@"returnsObjectsAsFaults"])) {
    fetchRequest.returnsObjectsAsFaults = [value boolValue];
  }

  if ((value = options[@"shouldRefreshRefetchedObjects"])) {
    fetchRequest.shouldRefreshRefetchedObjects = [value boolValue];
  }

  return fetchRequest;
}

+ (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors inContext:(NSManagedObjectContext *)context
{
  return [self fetchRequestWithPredicate:predicate sortDescriptors:sortDescriptors options:nil inContext:context];
}

+ (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors options:(NSDictionary *)options inContext:(NSManagedObjectContext *)context
{
  NSFetchRequest *request = [self fetchRequestWithOptions:options inContext:context];

  if (predicate) {
    request.predicate = predicate;
  }

  if (sortDescriptors) {
    request.sortDescriptors = sortDescriptors;
  }

  return request;
}

+ (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate sortedBy:(NSString *)sortBy ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context
{
  NSArray *sortDescriptors = nil;

  if (sortBy) {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortBy ascending:ascending];
    sortDescriptors = @[ sortDescriptor ];
  }

  return [self fetchRequestWithPredicate:predicate sortDescriptors:sortDescriptors options:nil inContext:context];
}

#pragma mark - NSFetchedResultsController helpers

+ (NSFetchedResultsController *)fetchedResultsControllerWithFetchRequest:(NSFetchRequest *)request sectionNameKeyPath:(NSString *)keyPath inContext:(NSManagedObjectContext *)context
{
  return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:keyPath cacheName:nil];
}

+ (NSFetchedResultsController *)fetchedResultsControllerWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors inContext:(NSManagedObjectContext *)context
{
  NSFetchRequest *request = [self fetchRequestWithPredicate:predicate sortDescriptors:sortDescriptors options:nil inContext:context];

  NSFetchedResultsController *controller = [self fetchedResultsControllerWithFetchRequest:request sectionNameKeyPath:nil inContext:context];

  return controller;
}

+ (NSFetchedResultsController *)fetchedResultsControllerWithPredicate:(NSPredicate *)predicate sortedBy:(NSString *)sortedBy ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context
{
  NSFetchRequest *request = [self fetchRequestWithPredicate:predicate sortedBy:sortedBy ascending:ascending inContext:context];

  NSFetchedResultsController *controller = [self fetchedResultsControllerWithFetchRequest:request sectionNameKeyPath:nil inContext:context];

  return controller;
}

+ (NSFetchedResultsController *)fetchedResultsControllerWithSectionNameKeyPath:(NSString *)keyPath predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors inContext:(NSManagedObjectContext *)context
{
  return [self fetchedResultsControllerWithSectionNameKeyPath:keyPath predicate:predicate sortDescriptors:sortDescriptors options:nil inContext:context];
}

+ (NSFetchedResultsController *)fetchedResultsControllerWithSectionNameKeyPath:(NSString *)keyPath predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors options:(NSDictionary *)options inContext:(NSManagedObjectContext *)context
{
  NSFetchRequest *request = [self fetchRequestWithPredicate:predicate sortDescriptors:sortDescriptors options:options inContext:context];

  NSFetchedResultsController *controller = [self fetchedResultsControllerWithFetchRequest:request sectionNameKeyPath:keyPath inContext:context];

  return controller;
}

#pragma mark - NSManagedObject helpers

+ (instancetype)insertIntoContext:(NSManagedObjectContext *)context
{
  NSEntityDescription *entity = [self entityInContext:context];
  return [[self alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
}

#pragma mark - Methods

- (instancetype)findInContext:(NSManagedObjectContext *)context;
{
  NSError *error;

  id object = [context existingObjectWithID:self.objectID error:&error];
  if (object == nil) {
    object = [context objectWithID:self.objectID];
  }

  // `context` may have a stale (cached) copy of the object; force a refresh
  [context refreshObject:object mergeChanges:YES];

  return object;
}

@end
