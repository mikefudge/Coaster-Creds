//
//  NearestParkViewController.m
//  Coaster Creds
//
//  Created by Mike Fudge on 16/03/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import "NearestParkViewController.h"
#import "Coaster.h"
#import "Park.h"
#import "CoreDataStack.h"
#import "Haversine.h"
#import "CoasterTableViewController.h"
#import "NearbyParkTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#define METERS_PER_MILE 1609.344

@interface NearestParkViewController () <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) Park *chosenPark;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIView *nearestView;
@property (weak, nonatomic) IBOutlet UITableView *nearbyView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
// Properties for nearest view
@property (weak, nonatomic) IBOutlet UILabel *nearestParkLabel;
@property (weak, nonatomic) IBOutlet UILabel *nearestParkDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nearestParkLastVisitLabel;
@property (weak, nonatomic) IBOutlet UILabel *nearestParkNumCoastersLabel;
// Properties for nearby view
@property (weak, nonatomic) IBOutlet UITableView *nearbyParksTableView;

@property (strong, nonatomic) NSMutableArray *nearbyParks;

@end

@implementation NearestParkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rideCount.title = [[NSString alloc] initWithFormat:@"%lu", (unsigned long)[self getCoasterCount]];
    self.nearestView.hidden = NO;
    self.nearbyView.hidden = YES;
    self.nearbyParks = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    
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
    
}

- (IBAction)buttonPressed:(id)sender {
    
    
    
    CLLocationDegrees lat = 52.987465;
    CLLocationDegrees lon = -1.886477;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    
    // MAP CODE
    CLLocationCoordinate2D locationForMap;
    locationForMap.latitude = lat;
    locationForMap.longitude = lon;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(locationForMap, 0.5 * METERS_PER_MILE, 0.5*METERS_PER_MILE);
    [self.mapView setRegion:viewRegion animated:YES];
    
    
    NSArray *resultsArray = [self findNearestParksFromLocation:location];
    Park *nearestPark = [resultsArray firstObject];
    
    [self.nearbyParks removeAllObjects];
    for (int i = 1; i < 4; i++) {
        Park *park = [resultsArray objectAtIndex:i];
        [self.nearbyParks addObject:park];
    }
    
    self.nearestParkLabel.text = nearestPark.name;
    self.nearestParkNumCoastersLabel.text = [NSString stringWithFormat:@"%lu coasters", (unsigned long)[nearestPark.coasters count]];
    self.nearestParkDistanceLabel.text = [NSString stringWithFormat:@"%.1f miles away", nearestPark.distance];
    self.chosenPark = nearestPark;
    
    [self.nearbyView reloadData];
}

- (IBAction)indexChanged:(id)sender {
    
    switch (self.segmentedControl.selectedSegmentIndex) {
        // Nearest
        case 0:
            self.nearestView.hidden = NO;
            self.nearbyView.hidden = YES;
            break;
        // Nearby
        case 1:
            self.nearestView.hidden = YES;
            self.nearbyView.hidden = NO;
            break;
        default:
            break; 
    }
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
    
    /*
    
    for (Park *park in sortedArray) {
        NSLog(@"%@ - %.1f miles away", park.name, park.distance);
    }
     
     */
    
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

- (NSUInteger)getCoasterCount {
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Coaster" inManagedObjectContext:coreDataStack.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timesRidden > 0"];
    [request setEntity:entity];
    [request setPredicate:predicate];
    NSArray *result = [coreDataStack.managedObjectContext executeFetchRequest:request error:nil];
    return result.count;
}

#pragma mark - Nearby Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.nearbyParks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NearbyParkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Park *park = [self.nearbyParks objectAtIndex:indexPath.row];
    cell.park = park;
    cell.parkNameLabel.text = park.name;
    cell.distanceAwayLabel.text = [NSString stringWithFormat:@"%.1f miles away", park.distance];
    cell.numCoastersLabel.text = [NSString stringWithFormat:@"%lu coasters", (unsigned long)[park.coasters count]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Park *park = [self.nearbyParks objectAtIndex:indexPath.row];
    self.chosenPark = park;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"coastersInPark"]) {
        
        CoasterTableViewController *coasterTableViewController = segue.destinationViewController;
        coasterTableViewController.park = self.chosenPark;
        coasterTableViewController.rideCount.title = self.rideCount.title;
    }
}

@end
