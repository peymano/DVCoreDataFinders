DVCoreDataFinders
=================

CoreData has a flexible yet verbose API. DVCoreDataFinders adds a handful of useful shorthand methods to `NSManagedObject` to find objects, create `NSFetchRequest` and `NSFetchedResultsController` objects, insert an object, etc.

Some examples:

    // find all JournalEntry objects
    NSArray *entries = [JournalEntry findAllInContext:managedObjectContext error:nil];

    // find all JournalEntry objects matching a predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"author = %@", email];
    NSArray *entries = [JournalEntry findAllWithPredicate:predicate inContext:managedObjectContext error:nil];

    // find the JournalEntry with id = 8
    JournalEntry *entry = [JournalEntry findFirstWhereProperty:@"id" equals:@(8) inContext:managedObjectContext error:nil];

    // insert a JournalEntry object
    JournalEntry *entity = [JournalEntry insertIntoContext:managedObjectContext];
    entity.title = @"a title";
    entity.createdAt = [NSDate date];
    ...

    // insert an new object if none found
    JournalEntry *entry = [JournalEntry findFirstOrInsertWhereProperty:@"author" equals:@@"joe@example.com" insertBlock:^(JournalEntry *createdObject) {
      createdObject.author = @"joe@example.com";
      createdObject.body = @"this is an example";
      ...
    } inContext:self.managedObjectContext error:nil];

### Global filter predicate

DVCoreDataFinders provides a global filter predicate, specified via `setGlobalFilterPredicate:`, which, when not `nil`,
adds the predicate to all queries (as an *and* predicate) when executed. For example, if you query for the predicate
`id > 5` and have set the global filter predicate to `isTombstone = NO`, the query that is executed is
`id > 5 AND isTombstone = NO`.

All methods
----------

    // counting
    + (NSUInteger)countAllInContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;
    + (NSUInteger)countAllWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;

    // Entity helpers
    + (NSEntityDescription *)entityInContext:(NSManagedObjectContext *)context;

    // Finders
    + (NSArray *)findAllInContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;
    + (NSArray *)findAllWithFetchRequest:(NSFetchRequest *)fetchRequest inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;
    + (NSArray *)findAllWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;
    + (NSArray *)findAllWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;
    + (NSArray *)findAllWithPredicate:(NSPredicate *)predicate sortedBy:(NSString *)sortBy ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;
    + (instancetype)findFirstWithFetchRequest:(NSFetchRequest *)fetchRequest inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;
    + (instancetype)findFirstOrInsertWithPredicate:(NSPredicate *)predicate insertBlock:(DVCoreDataFindersCreateBlock)insertBlock inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;
    + (instancetype)findFirstWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;
    + (instancetype)findFirstOrInsertWhereProperty:(NSString *)propertyName equals:(id)value insertBlock:(DVCoreDataFindersCreateBlock)insertBlock inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;
    + (instancetype)findFirstWhereProperty:(NSString *)propertyKey equals:(id)value inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;

    // NSFetchRequests helpers
    + (NSFetchRequest *)fetchRequest;
    + (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate;
    + (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors;
    + (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate sortedBy:(NSString *)sortBy ascending:(BOOL)ascending;

    // NSFetchedResultsController helpers
    + (NSFetchedResultsController *)fetchedResultsControllerWithFetchRequest:(NSFetchRequest *)request sectionNameKeyPath:(NSString *)keyPath inContext:(NSManagedObjectContext *)context;
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

Contact
-------

Peyman Oreizy @peymano

License
-------

DVCoreDataFinders is available under the Apache 2.0 license. See the LICENSE file for more info.
