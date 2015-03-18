//
//  Coaster.h
//  Coaster Creds
//
//  Created by Mike Fudge on 18/03/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Park;

@interface Coaster : NSManagedObject

@property (nonatomic) NSTimeInterval dateFirstRidden;
@property (nonatomic) NSTimeInterval dateLastRidden;
@property (nonatomic, retain) NSString * name;
@property (nonatomic) int16_t rating;
@property (nonatomic) int32_t timesRidden;
@property (nonatomic, retain) NSManagedObject *manufacturer;
@property (nonatomic, retain) Park *park;
@property (nonatomic, retain) NSManagedObject *type;

@end
