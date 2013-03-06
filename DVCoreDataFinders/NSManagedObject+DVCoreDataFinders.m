//
//  Created by Peyman Oreizy
//  Copyright 2011 Dynamic Variable LLC. All rights reserved.
//

#import "NSManagedObject+DVCoreDataFinders.h"


static const NSUInteger kDefaultBatchSize = 50;

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

#pragma mark - Finders

+ (NSArray *)executeFetchRequest:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr
{
  return [context executeFetchRequest:request error:errorPtr];
}

+ (NSArray *)findAllInContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr
{
  NSFetchRequest *fetchRequest = [self fetchRequestInContext:context];
  return [self executeFetchRequest:fetchRequest inContext:context error:errorPtr];
}

+ (NSArray *)findAllWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr
{
  NSFetchRequest *request = [self fetchRequestWithPredicate:predicate sortedBy:nil ascending:YES inContext:context];
  return [self executeFetchRequest:request inContext:context error:errorPtr];
}

+ (NSArray *)findAllWithPredicate:(NSPredicate *)predicate sortedBy:(NSString *)sortBy ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr
{
  NSFetchRequest *request = [self fetchRequestWithPredicate:predicate sortedBy:sortBy ascending:ascending inContext:context];
  return [self executeFetchRequest:request inContext:context error:errorPtr];
}

+ (id)findFirstWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr
{
  NSArray *results = [self findAllWithPredicate:predicate inContext:context error:errorPtr];

  if (results == nil || results.count == 0) {
    return nil;
  }

  return results[0];
}

+ (id)findFirstWhereProperty:(NSString *)propertyKey equals:(id)value inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", propertyKey, value];
  return [self findFirstWithPredicate:predicate inContext:context error:errorPtr];
}

#pragma mark - NSFetchRequest helpers

+ (NSFetchRequest *)fetchRequestInContext:(NSManagedObjectContext *)context
{
  return [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass(self.class)];
}

+ (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors inContext:(NSManagedObjectContext *)context
{
  NSFetchRequest *request = [self fetchRequestInContext:context];
  request.fetchBatchSize = kDefaultBatchSize;

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

  return [self fetchRequestWithPredicate:predicate sortDescriptors:sortDescriptors inContext:context];
}

#pragma mark - NSFetchRequestController helpers

+ (NSFetchedResultsController *)fetchResultsControllerWithFetchRequest:(NSFetchRequest *)request sectionNameKeyPath:(NSString *)keyPath inContext:(NSManagedObjectContext *)context
{
  return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:keyPath cacheName:nil];
}

+ (NSFetchedResultsController *)fetchResultsControllerWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors inContext:(NSManagedObjectContext *)context
{
  NSFetchRequest *request = [self fetchRequestWithPredicate:predicate sortDescriptors:sortDescriptors inContext:context];

  NSFetchedResultsController *controller = [self fetchResultsControllerWithFetchRequest:request sectionNameKeyPath:nil inContext:context];

  return controller;
}

+ (NSFetchedResultsController *)fetchResultsControllerWithPredicate:(NSPredicate *)predicate sortedBy:(NSString *)sortedBy ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context
{
  NSFetchRequest *request = [self fetchRequestWithPredicate:predicate sortedBy:sortedBy ascending:ascending inContext:context];

  NSFetchedResultsController *controller = [self fetchResultsControllerWithFetchRequest:request sectionNameKeyPath:nil inContext:context];

  return controller;
}

+ (NSFetchedResultsController *)fetchResultsControllerWithSectionNameKeyPath:(NSString *)keyPath predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors inContext:(NSManagedObjectContext *)context
{
  NSFetchRequest *request = [self fetchRequestWithPredicate:predicate sortDescriptors:sortDescriptors inContext:context];

  NSFetchedResultsController *controller = [self fetchResultsControllerWithFetchRequest:request sectionNameKeyPath:keyPath inContext:context];

  return controller;
}

#pragma mark - NSManagedObject helpers

+ (id)insertIntoContext:(NSManagedObjectContext *)context
{
  NSEntityDescription *entity = [self entityInContext:context];
  return [[self alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
}

#pragma mark - Methods

- (id)findInContext:(NSManagedObjectContext *)context;
{
  id object = [context objectWithID:self.objectID];

  // `context` may have a stale (cached) copy of the object; force a refresh
  [context refreshObject:object mergeChanges:YES];

  return object;
}

@end
