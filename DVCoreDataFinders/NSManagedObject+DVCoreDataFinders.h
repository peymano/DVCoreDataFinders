//
//  Created by Peyman Oreizy
//  Copyright 2011 Dynamic Variable LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

typedef void(^DVCoreDataFindersCreateBlock)(id _Nonnull createdObject);

@interface NSManagedObject (DVCoreDataFinders)

// Counters

+ (NSUInteger)countAllInContext:(NSManagedObjectContext * _Nonnull)context error:(NSError * _Nullable * _Nullable)errorPtr;

+ (NSUInteger)countAllWithPredicate:(NSPredicate * _Nullable)predicate inContext:(NSManagedObjectContext * _Nonnull)context error:(NSError * _Nullable * _Nullable)errorPtr;

// Entity helpers

+ (NSEntityDescription * _Nonnull)entityInContext:(NSManagedObjectContext * _Nonnull)context;

// Finders: find all

+ (NSArray * _Nullable)findAllInContext:(NSManagedObjectContext * _Nonnull)context error:(NSError * _Nullable * _Nullable)errorPtr;

+ (NSArray * _Nullable)findAllWithFetchRequest:(NSFetchRequest * _Nonnull)fetchRequest inContext:(NSManagedObjectContext * _Nonnull)context error:(NSError * _Nullable * _Nullable)errorPtr;

+ (NSArray * _Nullable)findAllWithPredicate:(NSPredicate * _Nonnull)predicate inContext:(NSManagedObjectContext * _Nonnull)context error:(NSError * _Nullable * _Nullable)errorPtr;

+ (NSArray * _Nullable)findAllWithPredicate:(NSPredicate * _Nullable)predicate sortDescriptors:(NSArray * _Nullable)sortDescriptors inContext:(NSManagedObjectContext * _Nonnull)context error:(NSError * _Nullable * _Nullable)errorPtr;

+ (NSArray * _Nullable)findAllWithPredicate:(NSPredicate * _Nullable)predicate sortedBy:(NSString * _Nullable)sortBy ascending:(BOOL)ascending inContext:(NSManagedObjectContext * _Nonnull)context error:(NSError * _Nullable * _Nullable)errorPtr;

// Finders: find first with a fetch request

+ (instancetype _Nullable)findFirstWithFetchRequest:(NSFetchRequest * _Nonnull)fetchRequest inContext:(NSManagedObjectContext * _Nonnull)context error:(NSError * _Nullable * _Nullable)errorPtr;

// Finders: find first with a predicate

+ (instancetype _Nonnull)findFirstOrInsertWithPredicate:(NSPredicate * _Nonnull)predicate insertBlock:(DVCoreDataFindersCreateBlock _Nullable)insertBlock inContext:(NSManagedObjectContext * _Nonnull)context error:(NSError * _Nullable * _Nullable)errorPtr;

+ (instancetype _Nullable)findFirstWithPredicate:(NSPredicate * _Nonnull)predicate inContext:(NSManagedObjectContext * _Nonnull)context error:(NSError * _Nullable * _Nullable)errorPtr;

// Finders: find first where "property = value"

+ (instancetype _Nullable)findFirstOrInsertWhereProperty:(NSString * _Nonnull)propertyName equals:(id _Nullable)value insertBlock:(DVCoreDataFindersCreateBlock _Nullable)insertBlock inContext:(NSManagedObjectContext * _Nonnull)context error:(NSError * _Nullable * _Nullable)errorPtr;

+ (instancetype _Nullable)findFirstWhereProperty:(NSString * _Nonnull)propertyName equals:(id _Nullable)value inContext:(NSManagedObjectContext * _Nonnull)context error:(NSError * _Nullable * _Nullable)errorPtr;

// NSFetchRequests helpers

+ (NSFetchRequest * _Nonnull)dv_fetchRequest;

+ (NSFetchRequest * _Nonnull)fetchRequestWithPredicate:(NSPredicate * _Nonnull)predicate;

+ (NSFetchRequest * _Nonnull)fetchRequestWithPredicate:(NSPredicate * _Nullable)predicate sortDescriptors:(NSArray * _Nullable)sortDescriptors;

+ (NSFetchRequest * _Nonnull)fetchRequestWithPredicate:(NSPredicate * _Nullable)predicate sortedBy:(NSString * _Nullable)sortBy ascending:(BOOL)ascending;

// NSFetchedResultsController helpers

+ (NSFetchedResultsController * _Nonnull)fetchedResultsControllerWithFetchRequest:(NSFetchRequest * _Nonnull)fetchRequest sectionNameKeyPath:(NSString * _Nullable)keyPath inContext:(NSManagedObjectContext * _Nonnull)context;

+ (NSFetchedResultsController * _Nonnull)fetchedResultsControllerWithPredicate:(NSPredicate * _Nullable)predicate sortDescriptors:(NSArray * _Nullable)sortDescriptors inContext:(NSManagedObjectContext * _Nonnull)context;

+ (NSFetchedResultsController * _Nonnull)fetchedResultsControllerWithPredicate:(NSPredicate * _Nullable)predicate sortedBy:(NSString * _Nullable)sortedBy ascending:(BOOL)ascending inContext:(NSManagedObjectContext * _Nonnull)context;

+ (NSFetchedResultsController * _Nonnull)fetchedResultsControllerWithPredicate:(NSPredicate * _Nullable)predicate sortDescriptors:(NSArray * _Nullable)sortDescriptors sectionNameKeyPath:(NSString * _Nullable)keyPath inContext:(NSManagedObjectContext * _Nonnull)context;

// Global filter predicate: if set, the global predicate is automatically added to all queries, all fetch requests, all fetched results controllers, etc.

+ (NSPredicate * _Nullable)globalFilterPredicate;

+ (void)setGlobalFilterPredicate:(NSPredicate * _Nullable)predicate;

// NSManagedObject helpers

+ (instancetype _Nonnull)insertIntoContext:(NSManagedObjectContext * _Nonnull)context;

// Instance methods

- (instancetype _Nullable)findInContext:(NSManagedObjectContext * _Nonnull)context;

@end
