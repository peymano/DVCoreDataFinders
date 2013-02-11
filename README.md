DVCoreDataFinders
=================

CoreData has a flexible yet verbose API. DVCoreDataFinders adds a handful of useful shorthand methods to `NSManagedObject` to find objects, create `NSFetchRequest` and `NSFetchedResultsController` objects, insert an object, etc.

Some examples:

    // find all JournalEntry objects
    NSArray *entries = [JournalEntry findAllInContext:self.managedObjectContext error:nil];

    // find all JournalEntry objects matching a predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"author = %@", email];
    NSArray *entries = [JournalEntry findAllWithPredicate:predicate inContext:self.managedObjectContext error:nil];

    // find the JournalEntry with id = 8
    JournalEntry *entry = [JournalEntry findOneWhereProperty:@"id" equals:@(8) inContext:self.managedObjectContext error:nil];

    // insert a JournalEntry object
    JournalEntry *entity = [JournalEntry insertIntoContext:self.managedObjectContext];
    entity.title = @"a title";
    entity.createdAt = [NSDate date];
    ...


All methods
----------

    // counting
    + (NSUInteger)countAllInContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;
    + (NSUInteger)countAllWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;

    // Entity helpers
    + (NSEntityDescription *)entityInContext:(NSManagedObjectContext *)context;

    // Finders
    + (NSArray *)findAllInContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;
    + (NSArray *)findAllWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;
    + (NSArray *)findAllWithPredicate:(NSPredicate *)predicate sortedBy:(NSString *)sortBy ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;
    + (id)findOneWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;
    + (id)findOneWhereProperty:(NSString *)propertyKey equals:(id)value inContext:(NSManagedObjectContext *)context error:(NSError **)errorPtr;

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

Contact
-------

Peyman Oreizy @peymano

License
-------

DVCoreDataFinders is available under the Apache 2.0 license. See the LICENSE file for more info.