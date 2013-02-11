//
//  Created by Peyman Oreizy
//  Copyright 2013 Dynamic Variable LLC. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "DVCoreDataFindersTests.h"
#import "NSManagedObject+DVCoreDataFinders.h"
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

- (void)testFindAllWithPredicateWithoutMatch
{
  NSArray *entries = [JournalEntry findAllWithPredicate:[NSPredicate predicateWithFormat:@"id > 15"] inContext:self.managedObjectContext error:nil];
  STAssertTrue(entries.count == 0, nil);
}

- (void)testFindOne
{
  JournalEntry *entry = [JournalEntry findOneWhereProperty:@"id" equals:@(8) inContext:self.managedObjectContext error:nil];
  STAssertNotNil(entry, nil);
  STAssertTrue(entry.id.integerValue == 8, nil);
}

- (void)testFindOneWithoutMatch
{
  JournalEntry *entry = [JournalEntry findOneWhereProperty:@"id" equals:@(15) inContext:self.managedObjectContext error:nil];
  STAssertNil(entry, nil);
}

- (void)testFindOneWithSimplePredicateMatching
{
  JournalEntry *entry = [JournalEntry findOneWithPredicate:[NSPredicate predicateWithFormat:@"title = %@", @"title 6"] inContext:self.managedObjectContext error:nil];
  STAssertNotNil(entry, nil);
  STAssertTrue(entry.id.integerValue == 6, nil);
}

- (void)testFindOneWithContainsPredicateMatching
{
  JournalEntry *entry = [JournalEntry findOneWithPredicate:[NSPredicate predicateWithFormat:@"body CONTAINS '6'"] inContext:self.managedObjectContext error:nil];
  STAssertNotNil(entry, nil);
  STAssertTrue(entry.id.integerValue == 6, nil);
}

- (void)testFindOneWithPredicateNotMatching
{
  JournalEntry *entry = [JournalEntry findOneWithPredicate:[NSPredicate predicateWithFormat:@"body CONTAINS '16'"] inContext:self.managedObjectContext error:nil];
  STAssertNil(entry, nil);
}


@end
