//
//  CoreDataStack.h
//  Coaster Creds
//
//  Created by Mike Fudge on 18/03/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataStack : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (instancetype)defaultStack;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
