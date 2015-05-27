//
//  ParkPointAnnotation.h
//  Coaster Creds
//
//  Created by Mike Fudge on 26/05/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "Park.h"

@interface ParkPointAnnotation : MKPointAnnotation

@property (strong, nonatomic) Park *park;

@end
