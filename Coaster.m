//
//  Coaster.m
//  Coaster Creds
//
//  Created by Mike Fudge on 10/04/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import "Coaster.h"
#import "Park.h"


@implementation Coaster

@dynamic dateFirstRidden;
@dynamic dateLastRidden;
@dynamic design;
@dynamic name;
@dynamic rating;
@dynamic ridden;
@dynamic type;
@dynamic park;

- (void)toggleRidden {
    self.ridden = !self.ridden;
}

@end
