//
//  Created by Peyman Oreizy
//  Copyright 2011 Dynamic Variable LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (DVCoreDataFinders)

// Counters

+ (NSUInteger)countAllInContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;

+ (NSUInteger)countAllWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;

// Entity helpers

+ (NSEntityDescription *)entityInContext:(NSManagedObjectContext *)context;

// Finders

+ (NSArray *)findAllInContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;

+ (NSArray *)findAllWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;

+ (NSArray *)findAllWithPredicate:(NSPredicate *)predicate sortedBy:(NSString *)sortBy ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;

+ (id)findFirstWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;

+ (id)findFirstWhereProperty:(NSString *)propertyKey equals:(id)value inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;

// NSFetchRequests helpers

+ (NSFetchRequest *)fetchRequestInContext:(NSManagedObjectContext *)context;

+ (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors inContext:(NSManagedObjectContext *)context;

+ (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate sortedBy:(NSString *)sortBy ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;

// NSFetchedResultsController helpers

+ (NSFetchedResultsController *)fetchResultsControllerWithFetchRequest:(NSFetchRequest *)request sectionNameKeyPath:(NSString *)keyPath inContext:(NSManagedObjectContext *)context;

+ (NSFetchedResultsController *)fetchResultsControllerWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors inContext:(NSManagedObjectContext *)context;

+ (NSFetchedResultsController *)fetchResultsControllerWithPredicate:(NSPredicate *)predicate sortedBy:(NSString *)sortedBy ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;

+ (NSFetchedResultsController *)fetchResultsControllerWithSectionNameKeyPath:(NSString *)keyPath predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors inContext:(NSManagedObjectContext *)context;

// NSManagedObject helpers

+ (id)insertIntoContext:(NSManagedObjectContext *)context;

// Instance methods

- (id)findInContext:(NSManagedObjectContext *)context;

@end
