//
//  ParkAnnotation.m
//  Coaster Creds
//
//  Created by Mike Fudge on 29/04/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import "ParkAnnotation.h"

@interface ParkAnnotation ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

@implementation ParkAnnotation

- (id)initWithName:(NSString *)name coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        if ([name isKindOfClass:[NSString class]]) {
            self.name = name;
        } else {
            self.name = @"Unknown park";
        }
        self.coordinate = coordinate;
    }
    return self;
}

@end

