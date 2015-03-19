//
//  nearestParkViewController.m
//  Coaster Creds
//
//  Created by Mike Fudge on 16/03/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import "nearestParkViewController.h"
#import "Park.h"
#import "Coaster.h"
#import "CoreDataStack.h"

#import <CoreLocation/CoreLocation.h>

@interface nearestParkViewController () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

@end

@implementation nearestParkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadLocation {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    // iOS 8 check, location authorisation
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    NSLog(@"Loading location");
    
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self.locationManager stopUpdatingLocation];
    self.currentLocation = [locations firstObject];
    
    NSLog(@"%@", self.currentLocation);
    
    //Park *park = [[Park alloc] init];
    //park.latitude = 52.987465;
    //park.longitude = -1.886477;
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:52.987465 longitude:-1.886477];
    
    NSLog(@"%.1f miles away", ([location distanceFromLocation:self.currentLocation] / 1609.344));
    
    //self.distanceLabel.text = [NSString stringWithFormat:@"Alton Towers is %f meters away", [self distanceToPark:park fromLocation:[locations firstObject]]];
    
}

- (double)distanceToPark:(Park *)park fromLocation:(CLLocation *)location {
    CLLocationDegrees lat = park.latitude;
    CLLocationDegrees lon = park.longitude;
    CLLocation *parkLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    return [location distanceFromLocation:parkLocation];
}

- (IBAction)buttonPressed:(id)sender {
    
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    
    [coreDataStack saveContext];
    
    [self loadLocation];
}


@end
