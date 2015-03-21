//
//  Coaster.h
//  Coaster Creds
//
//  Created by Mike Fudge on 19/03/2015.
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
@property (nonatomic) float rating;
@property (nonatomic) int32_t timesRidden;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) Park *park;

@end
