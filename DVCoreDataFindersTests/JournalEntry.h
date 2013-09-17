//
//  JournalEntry.h
//  DVCoreDataFinders
//
//  Created by Peyman Oreizy on 9/17/13.
//  Copyright (c) 2013 Dynamic Variable LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface JournalEntry : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * isTombstone;
@property (nonatomic, retain) NSString * title;

@end
