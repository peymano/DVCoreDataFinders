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

// Finders: find all

+ (NSArray *)findAllInContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;

+ (NSArray *)findAllWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;

+ (NSArray *)findAllWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors options:(NSDictionary *)options inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;

+ (NSArray *)findAllWithPredicate:(NSPredicate *)predicate sortedBy:(NSString *)sortBy ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;

+ (NSArray *)findAllWithPredicate:(NSPredicate *)predicate sortedBy:(NSString *)sortBy ascending:(BOOL)ascending options:(NSDictionary *)options inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;

// Finders: find first

+ (instancetype)findFirstWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;

+ (instancetype)findFirstWithPredicate:(NSPredicate *)predicate options:(NSDictionary *)options inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;

+ (instancetype)findFirstWhereProperty:(NSString *)propertyKey equals:(id)value inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;

+ (instancetype)findFirstWhereProperty:(NSString *)propertyKey equals:(id)value options:(NSDictionary *)options inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;

// NSFetchRequests helpers

+ (NSFetchRequest *)fetchRequestInContext:(NSManagedObjectContext *)context;

+ (NSFetchRequest *)fetchRequestWithOptions:(NSDictionary *)options inContext:(NSManagedObjectContext *)context;

+ (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors inContext:(NSManagedObjectContext *)context;

+ (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors options:(NSDictionary *)options inContext:(NSManagedObjectContext *)context;

+ (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate sortedBy:(NSString *)sortBy ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;

// NSFetchedResultsController helpers

+ (NSFetchedResultsController *)fetchedResultsControllerWithFetchRequest:(NSFetchRequest *)request sectionNameKeyPath:(NSString *)keyPath inContext:(NSManagedObjectContext *)context;

+ (NSFetchedResultsController *)fetchedResultsControllerWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors inContext:(NSManagedObjectContext *)context;

+ (NSFetchedResultsController *)fetchedResultsControllerWithPredicate:(NSPredicate *)predicate sortedBy:(NSString *)sortedBy ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;

+ (NSFetchedResultsController *)fetchedResultsControllerWithSectionNameKeyPath:(NSString *)keyPath predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors inContext:(NSManagedObjectContext *)context;

+ (NSFetchedResultsController *)fetchedResultsControllerWithSectionNameKeyPath:(NSString *)keyPath predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors options:(NSDictionary *)options inContext:(NSManagedObjectContext *)context;

// NSManagedObject helpers

+ (instancetype)insertIntoContext:(NSManagedObjectContext *)context;

// Instance methods

- (instancetype)findInContext:(NSManagedObjectContext *)context;

@end
