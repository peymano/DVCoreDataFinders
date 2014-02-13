//
//  Created by Peyman Oreizy
//  Copyright 2011 Dynamic Variable LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

typedef void(^DVCoreDataFindersBlock)(id createdObject);

@interface NSManagedObject (DVCoreDataFinders)

// Counters

+ (NSUInteger)countAllInContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;

+ (NSUInteger)countAllWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;

// Entity helpers

+ (NSEntityDescription *)entityInContext:(NSManagedObjectContext *)context;

// Finders: find all

+ (NSArray *)findAllInContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;

+ (NSArray *)findAllWithFetchRequest:(NSFetchRequest *)fetchRequest inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;

+ (NSArray *)findAllWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;

+ (NSArray *)findAllWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;

+ (NSArray *)findAllWithPredicate:(NSPredicate *)predicate sortedBy:(NSString *)sortBy ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;

// Finders: find first with a fetch request


// Finders: find first with a predicate

+ (instancetype)findFirstOrInsertWithPredicate:(NSPredicate *)predicate insertBlock:(DVCoreDataFindersBlock)insertBlock inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;

+ (instancetype)findFirstOrInsertWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;

+ (instancetype)findFirstAndUpdateOrInsertWithPredicate:(NSPredicate *)predicate updateBlock:(DVCoreDataFindersBlock)updateBlock inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;

+ (instancetype)findFirstWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;

// Finders: find first where "property = value"

+ (instancetype)findFirstOrInsertWhereProperty:(NSString *)propertyName equals:(id)value insertBlock:(DVCoreDataFindersBlock)insertBlock inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;

+ (instancetype)findFirstAndUpdateOrInsertWhereProperty:(NSString *)propertyName equals:(id)value updateBlock:(DVCoreDataFindersBlock)updateBlock inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;

+ (instancetype)findFirstWhereProperty:(NSString *)propertyName equals:(id)value inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;

// Delete: delete entries

+ (void)deleteAllWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;

// NSFetchRequests helpers

+ (NSFetchRequest *)fetchRequest;

+ (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate;

+ (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors;

+ (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate sortedBy:(NSString *)sortBy ascending:(BOOL)ascending;

// NSFetchedResultsController helpers

+ (NSFetchedResultsController *)fetchedResultsControllerWithFetchRequest:(NSFetchRequest *)fetchRequest sectionNameKeyPath:(NSString *)keyPath inContext:(NSManagedObjectContext *)context;

+ (NSFetchedResultsController *)fetchedResultsControllerWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors inContext:(NSManagedObjectContext *)context;

+ (NSFetchedResultsController *)fetchedResultsControllerWithPredicate:(NSPredicate *)predicate sortedBy:(NSString *)sortedBy ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;

+ (NSFetchedResultsController *)fetchedResultsControllerWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors sectionNameKeyPath:(NSString *)keyPath inContext:(NSManagedObjectContext *)context;

// Global filter predicate: if set, the global predicate is automatically added to all queries, all fetch requests, all fetched results controllers, etc.

+ (NSPredicate *)globalFilterPredicate;

+ (void)setGlobalFilterPredicate:(NSPredicate *)predicate;

// NSManagedObject helpers

+ (instancetype)insertIntoContext:(NSManagedObjectContext *)context;

// Instance methods

- (instancetype)findInContext:(NSManagedObjectContext *)context;

@end
