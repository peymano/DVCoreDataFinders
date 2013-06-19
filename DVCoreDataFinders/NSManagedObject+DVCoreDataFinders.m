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
  NSFetchRequest *request = [self fetchRequestWithPredicate:predicate sortedBy:nil ascending:YES];

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
  NSFetchRequest *fetchRequest = [self fetchRequest];
  return [context executeFetchRequest:fetchRequest error:errorPtr];
}

+ (NSArray *)findAllWithFetchRequest:(NSFetchRequest *)fetchRequest inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr
{
  return [context executeFetchRequest:fetchRequest error:errorPtr];
}

+ (NSArray *)findAllWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr
{
  NSFetchRequest *request = [self fetchRequestWithPredicate:predicate sortedBy:nil ascending:YES];
  return [context executeFetchRequest:request error:errorPtr];
}

+ (NSArray *)findAllWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;
{
  NSFetchRequest *fetchRequest = [self fetchRequestWithPredicate:predicate sortDescriptors:sortDescriptors];
  return [context executeFetchRequest:fetchRequest error:errorPtr];
}

+ (NSArray *)findAllWithPredicate:(NSPredicate *)predicate sortedBy:(NSString *)sortBy ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr
{
  NSArray *sortDescriptors = nil;

  if (sortBy) {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortBy ascending:ascending];
    sortDescriptors = @[ sortDescriptor ];
  }

  NSFetchRequest *request = [self fetchRequestWithPredicate:predicate sortDescriptors:sortDescriptors];
  return [context executeFetchRequest:request error:errorPtr];
}

#pragma mark - Finders: find first with a fetch request

+ (instancetype)findFirstWithFetchRequest:(NSFetchRequest *)fetchRequest inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;
{
  NSArray *results = [context executeFetchRequest:fetchRequest error:errorPtr];

  if (results == nil || results.count == 0) {
    return nil;
  }

  return results[0];
}

#pragma mark - Finders: find first with a predicate

+ (instancetype)findFirstOrInsertWithPredicate:(NSPredicate *)predicate insertBlock:(DVCoreDataFindersCreateBlock)createBlock inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;
{
  id object = [self findFirstWithPredicate:predicate inContext:context error:errorPtr];
  if (object) {
    return object;
  }

  object = [self insertIntoContext:context];

  if (createBlock) {
    createBlock(object);
  }

  return object;
}

+ (instancetype)findFirstWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr
{
  NSFetchRequest *fetchRequest = [self fetchRequestWithPredicate:predicate sortDescriptors:nil];

  fetchRequest.fetchLimit = 1;

  return [self findFirstWithFetchRequest:fetchRequest inContext:context error:errorPtr];
}

#pragma mark - find first where "property = value"

+ (instancetype)findFirstOrInsertWhereProperty:(NSString *)propertyName equals:(id)value insertBlock:(DVCoreDataFindersCreateBlock)insertBlock inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", propertyName, value];
  return [self findFirstOrInsertWithPredicate:predicate insertBlock:insertBlock inContext:context error:errorPtr];
}

+ (instancetype)findFirstWhereProperty:(NSString *)propertyName equals:(id)value inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", propertyName, value];
  return [self findFirstWithPredicate:predicate inContext:context error:errorPtr];
}

#pragma mark - NSFetchRequest helpers

+ (NSFetchRequest *)fetchRequest
{
  return [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass(self.class)];
}

+ (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate
{
  return [self fetchRequestWithPredicate:predicate sortDescriptors:nil];
}

+ (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors
{
  NSFetchRequest *request = [self fetchRequest];

  if (predicate) {
    request.predicate = predicate;
  }

  if (sortDescriptors) {
    request.sortDescriptors = sortDescriptors;
  }

  return request;
}

+ (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate sortedBy:(NSString *)sortBy ascending:(BOOL)ascending
{
  NSArray *sortDescriptors = nil;

  if (sortBy) {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortBy ascending:ascending];
    sortDescriptors = @[ sortDescriptor ];
  }

  return [self fetchRequestWithPredicate:predicate sortDescriptors:sortDescriptors];
}

#pragma mark - NSFetchedResultsController helpers

+ (NSFetchedResultsController *)fetchedResultsControllerWithFetchRequest:(NSFetchRequest *)fetchRequest sectionNameKeyPath:(NSString *)keyPath inContext:(NSManagedObjectContext *)context
{
  return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:keyPath cacheName:nil];
}

+ (NSFetchedResultsController *)fetchedResultsControllerWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors inContext:(NSManagedObjectContext *)context
{
  NSFetchRequest *fetchRequest = [self fetchRequestWithPredicate:predicate sortDescriptors:sortDescriptors];

  NSFetchedResultsController *controller = [self fetchedResultsControllerWithFetchRequest:fetchRequest sectionNameKeyPath:nil inContext:context];

  return controller;
}

+ (NSFetchedResultsController *)fetchedResultsControllerWithPredicate:(NSPredicate *)predicate sortedBy:(NSString *)sortedBy ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context
{
  NSFetchRequest *fetchRequest = [self fetchRequestWithPredicate:predicate sortedBy:sortedBy ascending:ascending];

  NSFetchedResultsController *controller = [self fetchedResultsControllerWithFetchRequest:fetchRequest sectionNameKeyPath:nil inContext:context];

  return controller;
}

+ (NSFetchedResultsController *)fetchedResultsControllerWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors sectionNameKeyPath:(NSString *)keyPath inContext:(NSManagedObjectContext *)context
{
  NSFetchRequest *fetchRequest = [self fetchRequestWithPredicate:predicate sortDescriptors:sortDescriptors];

  NSFetchedResultsController *controller = [self fetchedResultsControllerWithFetchRequest:fetchRequest sectionNameKeyPath:keyPath inContext:context];

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
