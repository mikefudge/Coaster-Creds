//
//  MapAnnotation.h
//  Coaster Creds
//
//  Created by Mike Fudge on 30/03/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation>

- (id)initWithName:(NSString *)name coordinate:(CLLocationCoordinate2D *)coordinate;

@end
