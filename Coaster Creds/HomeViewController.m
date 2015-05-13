//
//  HomeViewController.m
//  Coaster Creds
//
//  Created by Mike Fudge on 16/03/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import "HomeViewController.h"
#import "Coaster.h"
#import "Park.h"
#import "CoreDataStack.h"
#import "Haversine.h"
#import "CoasterTableViewController.h"
#import "HomeTableViewCell.h"
#import "ErrorTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Chameleon.h"

#define METERS_PER_MILE 1609.344
#define NUMBER_OF_PARKS 5

@interface HomeViewController () <CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) Park *selectedPark;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) NSMutableArray *parksArray;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *mapBackButton;
@property (nonatomic) CGRect containerViewOrigin;
@property (nonatomic) CGRect mapViewOrigin;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property BOOL updateLocationDidFail;
@property (strong, nonatomic) NSError *error;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.estimatedRowHeight = 98.0;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _parksArray = [[NSMutableArray alloc] init];
    _mapBackButton.enabled = NO;
    _mapViewOrigin = _mapView.frame;
    _containerViewOrigin = _containerView.frame;
    
    [self startRefreshActivityIndicator];
    [self loadLocation];
}

- (void)viewWillAppear:(BOOL)animated {
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// Top right refresh button
- (IBAction)refreshLocation:(id)sender {
    [self startRefreshActivityIndicator];
    [self loadLocation];
}

- (void)startRefreshActivityIndicator {
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    UIBarButtonItem *activityButton = [[UIBarButtonItem alloc] initWithCustomView:_activityIndicator];
    [self navigationItem].rightBarButtonItem = activityButton;
    [_activityIndicator startAnimating];
}

- (void)stopRefreshActivityIndicator {
    [_activityIndicator stopAnimating];
    [self navigationItem].rightBarButtonItem = _refreshButton;
}

#pragma mark Find Park Logic

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
    return sortedArray;
}


#pragma mark Cell Display

- (NSString *)formatStringForNumber:(long)number {
    NSString *string = [[NSString alloc] init];
    if (number == 0) {
        string = @"No coasters";
    } else if (number == 1) {
        string = @"1 coaster";
    } else {
        string = [NSString stringWithFormat:@"%lu coasters", number];
    }
    return string;
}

- (void)hideLabel:(UILabel *)label isHidden:(BOOL)value {
    label.hidden = value;
}

- (NSString *)setNumCoastersLabelForPark:(Park *)park {
    int count = 0;
    int total = 0;
    
    for (Coaster *coaster in park.coasters) {
        if (coaster.isOpen == YES) {
            total++;
            if (coaster.ridden == YES) {
                count++;
            }
        }
    }
    NSString *string = [[NSString alloc] initWithFormat:@"%d/%d", count, total];
    return string;
}

- (UIColor *)getNumCoastersLabelColorForPark:(Park *)park {
    int count = 0;
    float total = 0;
    for (Coaster *coaster in park.coasters) {
        if (coaster.isOpen == YES) {
            total++;
            if (coaster.ridden == YES) {
                count++;
            }
        }
    }
    float percentage = count / total;
    
    // Red - < 25% ridden
    if (percentage >= 0 && percentage < 0.25 && total != 0) {
        return [UIColor flatRedColor];
    }
    // Orange - < 50% ridden
    else if (percentage >= 0.25 && percentage < 0.5) {
        return [UIColor flatOrangeColor];
    }
    // Yellow - < 75% ridden
    else if (percentage >= 0.5 && percentage < 0.75) {
        return [UIColor flatYellowColor];
    }
    // Otherwise green
    else if (percentage >= 0.75 && percentage < 1) {
        return [UIColor flatLimeColor];
    } else {
        return [UIColor flatGreenColor];
    }
}

- (NSString *)getErrorMessage:(NSError *)error {
    switch ([error code]) {
        case kCLErrorNetwork: {
            NSString *errorMessage = @"Could not retrieve your location. Please check your GPS & network settings.";
            return errorMessage;
        }
            break;
        case kCLErrorDenied: {
            NSString *errorMessage = @"Location services disabled. Please allow location services to access this app in settings.";
            return errorMessage;
        }
            break;
        default: {
            NSString *errorMessage = @"Unknown network error. Please check your network settings.";
            return errorMessage;
        }
            break;
    }
}

#pragma mark Map View

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *identifier = @"Park";
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        [annotationView setSelected:YES animated:YES];
    } else {
        annotationView.annotation = annotation;
        annotationView.animatesDrop = YES;
    }
    
    return annotationView;
}

- (void)zoomToFitMapAnnotations:(MKMapView *)mapView withPadding:(CGFloat)padding {
    if ([mapView.annotations count] == 0) {
        return;
    }
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for (id <MKAnnotation> annotation in mapView.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    // Add a little space on the sides
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * padding;
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * padding;
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
}

- (void)addAnnotationsToMap:(MKMapView *)mapView fromArray:(NSArray *)array {
    for (Park *park in array) {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(park.latitude, park.longitude);
        annotation.coordinate = coord;
        annotation.title = park.name;
        [mapView addAnnotation:annotation];
    }
}

#pragma mark Location Services

- (void)loadLocation {
    self.locationManager = [[CLLocationManager alloc] init];
    [_mapView removeAnnotations:_mapView.annotations];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // iOS 8 check, location authorisation
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self.locationManager stopUpdatingLocation];
    [self stopRefreshActivityIndicator];
    _updateLocationDidFail = NO;
    self.currentLocation = [locations lastObject];
    NSArray *resultsArray = [self findNearestParksFromLocation:self.currentLocation];
    // Refresh parks array with results
    [self.parksArray removeAllObjects];
    for (int i = 0; i < NUMBER_OF_PARKS; i++) {
        Park *park = [resultsArray objectAtIndex:i];
        [self.parksArray addObject:park];
    }
    
    [self addAnnotationsToMap:_mapView fromArray:_parksArray];
    [self zoomToFitMapAnnotations:_mapView withPadding:1.2];
    [_tableView reloadData];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [_locationManager stopUpdatingLocation];
    [self stopRefreshActivityIndicator];
    [_mapView removeAnnotations:_mapView.annotations];
    _updateLocationDidFail = YES;
    _error = error;
    [_tableView reloadData];
}


#pragma mark Table View Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_updateLocationDidFail) {
        return 1;
    } else {
        return [_parksArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_updateLocationDidFail) {
        ErrorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ErrorCell" forIndexPath:indexPath];
        cell.errorLabel.text = [self getErrorMessage:_error];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userInteractionEnabled = NO;
        return cell;
    } else {
        HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        Park *park = [_parksArray objectAtIndex:indexPath.row];
        cell.userInteractionEnabled = YES;
        cell.parkNameLabel.text = park.name;
        cell.parkDistanceLabel.text = [[NSString alloc] initWithFormat:@"%.1f mi", park.distance];
        cell.numCoastersLabel.layer.cornerRadius = 25;
        cell.numCoastersLabel.clipsToBounds = YES;
        cell.numCoastersLabel.backgroundColor = [self getNumCoastersLabelColorForPark:park];
        cell.numCoastersLabel.text = [self setNumCoastersLabelForPark:park];
        cell.parkAreaLabel.text = [[NSString alloc] initWithFormat:@"%@, %@", park.state, park.country];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedPark = [_parksArray objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"coastersInPark" sender:self];
}

#pragma mark Core Data

- (NSArray *)getAllParks {
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Park" inManagedObjectContext:coreDataStack.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isOpen == YES"];
    [request setEntity:entity];
    [request setPredicate:predicate];
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

#pragma mark Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"coastersInPark"]) {
        CoasterTableViewController *coasterTableViewController = segue.destinationViewController;
        coasterTableViewController.hidesBottomBarWhenPushed = YES;
        coasterTableViewController.park = _selectedPark;
    }
}

@end
