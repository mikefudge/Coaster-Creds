//
//  Park.h
//  Coaster Creds
//
//  Created by Mike Fudge on 18/03/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Coaster;

@interface Park : NSManagedObject

@property (nonatomic, retain) NSString * country;
@property (nonatomic) NSTimeInterval dateLastVisited;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic) int32_t numberOfVisits;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSSet *coasters;
@end

@interface Park (CoreDataGeneratedAccessors)

- (void)addCoastersObject:(Coaster *)value;
- (void)removeCoastersObject:(Coaster *)value;
- (void)addCoasters:(NSSet *)values;
- (void)removeCoasters:(NSSet *)values;

@end