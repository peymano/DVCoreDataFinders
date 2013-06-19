//
//  Created by Peyman Oreizy
//  Copyright 2013 Dynamic Variable LLC. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "DVCoreDataFindersTests.h"
#import "DVCoreDataFinders.h"
#import "JournalEntry.h"

@implementation DVCoreDataFindersTests
{
  NSManagedObjectContext *_managedObjectContext;
  NSManagedObjectModel *_managedObjectModel;
  NSPersistentStoreCoordinator *_persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext
{
  if (_managedObjectContext == nil) {
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
      _managedObjectContext = [[NSManagedObjectContext alloc] init];
      [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
  }
  return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
  if (_managedObjectModel == nil) {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *modelURL = [bundle URLForResource:@"Tests" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  }
  return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
  if (_persistentStoreCoordinator == nil) {
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Tests.sqlite"];

    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];

    NSError *error = nil;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }
  }
  return _persistentStoreCoordinator;
}

- (void)destroyPersistentStoreCoordinator
{
  NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Tests.sqlite"];

  NSPersistentStore *persistentStore = [_persistentStoreCoordinator persistentStoreForURL:storeURL];

  if (!persistentStore) {
    return;
  }

  NSError *error = nil;

  if (![_persistentStoreCoordinator removePersistentStore:persistentStore error:&error]) {
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }

  // Delete the underlying file

  if ([[NSFileManager defaultManager] fileExistsAtPath:storeURL.path]) {
    if (![[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:&error]) {
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }
  }
}

- (NSURL *)applicationDocumentsDirectory
{
  return [NSURL fileURLWithPath:NSTemporaryDirectory()];
}

#pragma mark - Test setup & tear down

- (void)setUp
{
  [super setUp];

  for (int i = 0; i < 10; i++) {
    JournalEntry *entity = [JournalEntry insertIntoContext:self.managedObjectContext];
    entity.title = [NSString stringWithFormat:@"title %d", i];
    entity.body = [NSString stringWithFormat:@"description %d", i];
    entity.createdAt = [NSDate date];
    entity.id = @(i);
  }

  [self.managedObjectContext save:nil];
}

- (void)tearDown
{
  [self destroyPersistentStoreCoordinator];
  _managedObjectContext = nil;
  _managedObjectModel = nil;
  _persistentStoreCoordinator = nil;
  [super tearDown];
}

#pragma mark - Tests

- (void)testFindAll
{
  NSArray *entries = [JournalEntry findAllInContext:self.managedObjectContext error:nil];
  STAssertTrue(entries.count == 10, nil);
}

- (void)testFindAllWithPredicate
{
  NSArray *entries = [JournalEntry findAllWithPredicate:[NSPredicate predicateWithFormat:@"id >= 5"] inContext:self.managedObjectContext error:nil];
  STAssertTrue(entries.count == 5, nil);
}

- (void)testFindAllExcludingPendingChanges
{
  JournalEntry *journalEntry = [JournalEntry insertIntoContext:self.managedObjectContext];
  journalEntry.id = @(100);

  NSArray *entries;
  NSError *error;

  entries = [JournalEntry findAllWithPredicate:[NSPredicate predicateWithFormat:@"id >= 5"] sortDescriptors:nil inContext:self.managedObjectContext error:&error];
  STAssertTrue(entries.count == 6, nil);

  // with includesPendingChanges=NO
  NSFetchRequest *fetchRequest = [JournalEntry fetchRequestWithPredicate:[NSPredicate predicateWithFormat:@"id >= 5"]];
  fetchRequest.includesPendingChanges = NO;
  entries = [JournalEntry findAllWithFetchRequest:fetchRequest inContext:self.managedObjectContext error:nil];
  STAssertTrue(entries.count == 5, nil);
}

- (void)testFindAllWithPredicateWithoutMatch
{
  NSArray *entries = [JournalEntry findAllWithPredicate:[NSPredicate predicateWithFormat:@"id > 15"] inContext:self.managedObjectContext error:nil];
  STAssertTrue(entries.count == 0, nil);
}

- (void)testFindFirst
{
  JournalEntry *entry = [JournalEntry findFirstWhereProperty:@"id" equals:@(8) inContext:self.managedObjectContext error:nil];
  STAssertNotNil(entry, nil);
  STAssertTrue(entry.id.integerValue == 8, nil);
}

- (void)testFindFirstWithoutMatch
{
  JournalEntry *entry = [JournalEntry findFirstWhereProperty:@"id" equals:@(15) inContext:self.managedObjectContext error:nil];
  STAssertNil(entry, nil);
}

- (void)testFindFirstWithSimplePredicateMatching
{
  JournalEntry *entry = [JournalEntry findFirstWithPredicate:[NSPredicate predicateWithFormat:@"title = %@", @"title 6"] inContext:self.managedObjectContext error:nil];
  STAssertNotNil(entry, nil);
  STAssertTrue(entry.id.integerValue == 6, nil);
}

- (void)testFindFirstWithContainsPredicateMatching
{
  JournalEntry *entry = [JournalEntry findFirstWithPredicate:[NSPredicate predicateWithFormat:@"body CONTAINS '6'"] inContext:self.managedObjectContext error:nil];
  STAssertNotNil(entry, nil);
  STAssertTrue(entry.id.integerValue == 6, nil);
}

- (void)testFindFirstWithPredicateNotMatching
{
  JournalEntry *entry = [JournalEntry findFirstWithPredicate:[NSPredicate predicateWithFormat:@"body CONTAINS '16'"] inContext:self.managedObjectContext error:nil];
  STAssertNil(entry, nil);
}

- (void)testFindFirstOrInsertWithPredicateAndFinding
{
  JournalEntry *entry = [JournalEntry findFirstOrInsertWithPredicate:[NSPredicate predicateWithFormat:@"body CONTAINS '7'"] insertBlock:^(JournalEntry *createdObject) {
    createdObject.id = @(17);
    createdObject.body = @"this is 17";
  } inContext:self.managedObjectContext error:nil];

  STAssertNotNil(entry, nil);
  STAssertTrue(entry.id.integerValue == 7, nil);
}

- (void)testFindFirstOrInsertWithPredicateAndInserting
{
  JournalEntry *entry = [JournalEntry findFirstOrInsertWithPredicate:[NSPredicate predicateWithFormat:@"body CONTAINS '17'"] insertBlock:^(JournalEntry *createdObject) {
    createdObject.id = @(17);
    createdObject.body = @"this is 17";
  } inContext:self.managedObjectContext error:nil];

  STAssertNotNil(entry, nil);
  STAssertTrue(entry.id.integerValue == 17, nil);
  STAssertEqualObjects(entry.body, @"this is 17", nil);
}

- (void)testFindFirstOrInsertWhereAndFinding
{
  JournalEntry *entry = [JournalEntry findFirstOrInsertWhereProperty:@"id" equals:@(7) insertBlock:^(JournalEntry *createdObject) {
    createdObject.id = @(17);
    createdObject.body = @"this is 17";
  } inContext:self.managedObjectContext error:nil];

  STAssertNotNil(entry, nil);
  STAssertTrue(entry.id.integerValue == 7, nil);
}

- (void)testFindFirstOrInsertWhereAndInserting
{
  JournalEntry *entry = [JournalEntry findFirstOrInsertWhereProperty:@"id" equals:@(17) insertBlock:^(JournalEntry *createdObject) {
    createdObject.id = @(17);
    createdObject.body = @"this is 17";
  } inContext:self.managedObjectContext error:nil];

  STAssertNotNil(entry, nil);
  STAssertTrue(entry.id.integerValue == 17, nil);
}

@end
