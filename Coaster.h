//
//  Coaster.h
//  Coaster Creds
//
//  Created by Mike Fudge on 14/05/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Park;

@interface Coaster : NSManagedObject

@property (nonatomic, retain) NSDate * dateFirstRidden;
@property (nonatomic, retain) NSDate * dateLastRidden;
@property (nonatomic, retain) NSString * design;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic) BOOL ridden;
@property (nonatomic, retain) NSString * type;
@property (nonatomic) int16_t year;
@property (nonatomic) int32_t coasterid;
@property (nonatomic) int16_t status;
@property (nonatomic, retain) Park *park;

- (void)toggleRidden;

@end
