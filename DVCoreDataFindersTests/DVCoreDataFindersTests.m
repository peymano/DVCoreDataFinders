//
//  Created by Peyman Oreizy
//  Copyright 2013 Dynamic Variable LLC. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <XCTest/XCTest.h>
#import "DVCoreDataFinders.h"
#import "JournalEntry.h"

@interface DVCoreDataFindersTests : XCTestCase

@end

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
      _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
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
    entity.body = [NSString stringWithFormat:@"description %d", i];
    entity.createdAt = [NSDate date];
    entity.id = @(i);
    entity.isTombstone = (i % 2) ? @YES : @NO;
    entity.title = [NSString stringWithFormat:@"title %d", i];
  }

  [self.managedObjectContext save:nil];

  [JournalEntry setGlobalFilterPredicate:nil];
}

- (void)tearDown
{
  [self destroyPersistentStoreCoordinator];
  _managedObjectContext = nil;
  _managedObjectModel = nil;
  _persistentStoreCoordinator = nil;
  [super tearDown];
}

#pragma mark - Find all tests

- (void)testFindAll
{
  NSArray *entries = [JournalEntry findAllInContext:self.managedObjectContext error:nil];
  XCTAssertEqual(entries.count, 10);
}

- (void)testFindAllWithPredicate
{
  NSArray *entries = [JournalEntry findAllWithPredicate:[NSPredicate predicateWithFormat:@"id >= 5"] inContext:self.managedObjectContext error:nil];
  XCTAssertEqual(entries.count, 5);
}

- (void)testFindAllExcludingPendingChanges
{
  JournalEntry *journalEntry = [JournalEntry insertIntoContext:self.managedObjectContext];
  journalEntry.id = @(100);

  NSArray *entries;
  NSError *error;

  entries = [JournalEntry findAllWithPredicate:[NSPredicate predicateWithFormat:@"id >= 5"] sortDescriptors:nil inContext:self.managedObjectContext error:&error];
  XCTAssertEqual(entries.count, 6);

  // with includesPendingChanges=NO
  NSFetchRequest *fetchRequest = [JournalEntry fetchRequestWithPredicate:[NSPredicate predicateWithFormat:@"id >= 5"]];
  fetchRequest.includesPendingChanges = NO;
  entries = [JournalEntry findAllWithFetchRequest:fetchRequest inContext:self.managedObjectContext error:nil];
  XCTAssertEqual(entries.count, 5);
}

- (void)testFindAllWithPredicateWithoutMatch
{
  NSArray *entries = [JournalEntry findAllWithPredicate:[NSPredicate predicateWithFormat:@"id > 15"] inContext:self.managedObjectContext error:nil];
  XCTAssertEqual(entries.count, 0);
}

#pragma mark - Find first tests

- (void)testFindFirst
{
  JournalEntry *entry = [JournalEntry findFirstWhereProperty:@"id" equals:@(8) inContext:self.managedObjectContext error:nil];
  XCTAssertNotNil(entry);
  XCTAssertEqual(entry.id.integerValue, 8);
}

- (void)testFindFirstWithoutMatch
{
  JournalEntry *entry = [JournalEntry findFirstWhereProperty:@"id" equals:@(15) inContext:self.managedObjectContext error:nil];
  XCTAssertNil(entry);
}

- (void)testFindFirstWithSimplePredicateMatching
{
  JournalEntry *entry = [JournalEntry findFirstWithPredicate:[NSPredicate predicateWithFormat:@"title = %@", @"title 6"] inContext:self.managedObjectContext error:nil];
  XCTAssertNotNil(entry);
  XCTAssertEqual(entry.id.integerValue, 6);
}

- (void)testFindFirstWithContainsPredicateMatching
{
  JournalEntry *entry = [JournalEntry findFirstWithPredicate:[NSPredicate predicateWithFormat:@"body CONTAINS '6'"] inContext:self.managedObjectContext error:nil];
  XCTAssertNotNil(entry);
  XCTAssertEqual(entry.id.integerValue, 6);
}

- (void)testFindFirstWithPredicateNotMatching
{
  JournalEntry *entry = [JournalEntry findFirstWithPredicate:[NSPredicate predicateWithFormat:@"body CONTAINS '16'"] inContext:self.managedObjectContext error:nil];
  XCTAssertNil(entry);
}

#pragma mark - Find first or insert tests

- (void)testFindFirstOrInsertWithPredicateAndFinding
{
  JournalEntry *entry = [JournalEntry findFirstOrInsertWithPredicate:[NSPredicate predicateWithFormat:@"body CONTAINS '7'"] insertBlock:^(JournalEntry *createdObject) {
    createdObject.id = @(17);
    createdObject.body = @"this is 17";
  } inContext:self.managedObjectContext error:nil];

  XCTAssertNotNil(entry);
  XCTAssertEqual(entry.id.integerValue, 7);
}

- (void)testFindFirstOrInsertWithPredicateAndInserting
{
  JournalEntry *entry = [JournalEntry findFirstOrInsertWithPredicate:[NSPredicate predicateWithFormat:@"body CONTAINS '17'"] insertBlock:^(JournalEntry *createdObject) {
    createdObject.id = @(17);
    createdObject.body = @"this is 17";
  } inContext:self.managedObjectContext error:nil];

  XCTAssertNotNil(entry);
  XCTAssertEqual(entry.id.integerValue, 17);
  XCTAssertEqualObjects(entry.body, @"this is 17");
}

- (void)testFindFirstOrInsertWhereAndFinding
{
  JournalEntry *entry = [JournalEntry findFirstOrInsertWhereProperty:@"id" equals:@(7) insertBlock:^(JournalEntry *createdObject) {
    createdObject.id = @(17);
    createdObject.body = @"this is 17";
  } inContext:self.managedObjectContext error:nil];

  XCTAssertNotNil(entry);
  XCTAssertEqual(entry.id.integerValue, 7);
}

- (void)testFindFirstOrInsertWhereAndInserting
{
  JournalEntry *entry = [JournalEntry findFirstOrInsertWhereProperty:@"id" equals:@(17) insertBlock:^(JournalEntry *createdObject) {
    createdObject.id = @(17);
    createdObject.body = @"this is 17";
  } inContext:self.managedObjectContext error:nil];

  XCTAssertNotNil(entry);
  XCTAssertEqual(entry.id.integerValue, 17);
}

#pragma mark - Global filter predicate tests

- (void)setGlobalFilterPredicate
{
  NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"isTombstone = NO"];
  [JournalEntry setGlobalFilterPredicate:filterPredicate];
}

- (void)testGlobalFilterPredicateWithFindAll
{
  [self setGlobalFilterPredicate];

  NSArray *results = [JournalEntry findAllInContext:self.managedObjectContext error:nil];
  XCTAssertEqual(results.count, 5);
}

- (void)testGlobalFilterPredicateWithFindAllWithPredicate
{
  [self setGlobalFilterPredicate];

  NSArray *entries = [JournalEntry findAllWithPredicate:[NSPredicate predicateWithFormat:@"id >= 5"] inContext:self.managedObjectContext error:nil];
  XCTAssertEqual(entries.count, 2);

  [entries enumerateObjectsUsingBlock:^(JournalEntry *journalEntry, NSUInteger idx, BOOL *stop) {
    XCTAssertFalse(journalEntry.isTombstone.boolValue);
  }];
}

- (void)testGlobalFilterPredicateWithFindAllWithFetchRequest
{
  [self setGlobalFilterPredicate];

  // test using `fetchRequestWithPredicate:`
  NSFetchRequest *fetchRequest = [JournalEntry fetchRequestWithPredicate:[NSPredicate predicateWithFormat:@"id >= 7"]];
  NSArray *entries = [JournalEntry findAllWithFetchRequest:fetchRequest inContext:self.managedObjectContext error:nil];
  XCTAssertEqual(entries.count, 1);

  // test using `[NSFetchRequest alloc] initWithEntityName:`
  NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc] initWithEntityName:@"JournalEntry"];
  fetchRequest2.predicate = [NSPredicate predicateWithFormat:@"id >= 7"];
  NSArray *entries2 = [JournalEntry findAllWithFetchRequest:fetchRequest2 inContext:self.managedObjectContext error:nil];
  XCTAssertEqual(entries2.count, 1);
}

- (void)testGlobalFilterPredicateWithFindFirstWithPredicate
{
  [self setGlobalFilterPredicate];

  // object found

  JournalEntry *entry = [JournalEntry findFirstWithPredicate:[NSPredicate predicateWithFormat:@"title = %@", @"title 6"] inContext:self.managedObjectContext error:nil];
  XCTAssertNotNil(entry);
  XCTAssertEqual(entry.id.integerValue, 6);

  // object not found

  JournalEntry *entry2 = [JournalEntry findFirstWithPredicate:[NSPredicate predicateWithFormat:@"title = %@", @"title 7"] inContext:self.managedObjectContext error:nil];
  XCTAssertNil(entry2);
}

@end
