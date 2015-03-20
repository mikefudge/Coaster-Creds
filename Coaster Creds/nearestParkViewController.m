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
#import "Haversine.h"

#import <CoreLocation/CoreLocation.h>

@interface nearestParkViewController () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (weak, nonatomic) IBOutlet UILabel *nearestParkLabel;
@property (weak, nonatomic) IBOutlet UILabel *nearestParkStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nearestParkNumCoastersLabel;
@property (weak, nonatomic) IBOutlet UILabel *nearestParkDistance;

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
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // iOS 8 check, location authorisation
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    NSLog(@"Loading location");
    
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self.locationManager stopUpdatingLocation];
    self.currentLocation = [locations lastObject];
    
    NSLog(@"%@", self.currentLocation);
    
    //CLLocation *location = [[CLLocation alloc] initWithLatitude:52.987465 longitude:-1.886477];
    
    //NSLog(@"%.1f miles away", ([location distanceFromLocation:self.currentLocation] / 1609.344));
    
}

- (double)distanceToPark:(Park *)park fromLocation:(CLLocation *)location {
    CLLocationDegrees lat = park.latitude;
    CLLocationDegrees lon = park.longitude;
    CLLocation *parkLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    return [location distanceFromLocation:parkLocation];
}

- (IBAction)buttonPressed:(id)sender {
    
    CLLocationDegrees lat = 52.344139;
    CLLocationDegrees lon = -2.265646;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    
    
    NSArray *resultsArray = [self findNearestParksFromLocation:location];
    Park *nearestPark = [resultsArray firstObject];
    self.nearestParkLabel.text = nearestPark.name;
    self.nearestParkStateLabel.text = [NSString stringWithFormat:@"%@, %@", nearestPark.state, nearestPark.country];
    self.nearestParkNumCoastersLabel.text = [NSString stringWithFormat:@"%lu coasters", (unsigned long)[nearestPark.coasters count]];
    self.nearestParkDistance.text = [NSString stringWithFormat:@"%.1f miles away", nearestPark.distance];
    
    //[self loadLocation];
}

- (NSArray *)findNearestParksFromLocation:(CLLocation *)location {
    
    NSArray *parkList = [self getAllParks];
    Haversine *haversine = [[Haversine alloc] init];
    for (Park *park in parkList) {
        haversine.lat1 = park.latitude;
        haversine.lon1 = park.longitude;
        haversine.lat2 = location.coordinate.latitude;
        haversine.lon2 = location.coordinate.longitude;
        park.distance = [haversine toMiles];
    }
    NSArray *sortDescriptor = @[[NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES]];
    NSArray *sortedArray = [parkList sortedArrayUsingDescriptors:sortDescriptor];
    
    for (Park *park in sortedArray) {
        NSLog(@"%@ - %.1f miles away", park.name, park.distance);
    }
    
    return sortedArray;
    
}

- (NSArray *)getAllParks {
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Park" inManagedObjectContext:coreDataStack.managedObjectContext];
    [request setEntity:entity];
    NSArray *result = [coreDataStack.managedObjectContext executeFetchRequest:request error:nil];
    return result;
}


@end
