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
#import "HomeMapViewController.h"
#import "ODRefreshControl.h"

#define METERS_PER_MILE 1609.344

@interface HomeViewController () <CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) Park *selectedPark;
@property (strong, nonatomic) NSArray *parksArray;
@property (nonatomic) CGRect containerViewOrigin;
@property (nonatomic) CGRect mapViewOrigin;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *optionsTableView;
@property BOOL updateLocationDidFail;
@property (strong, nonatomic) NSError *error;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *mapButton;
@property (strong, nonatomic) NSString *postcode;
@property (strong, nonatomic) ODRefreshControl *refreshControl;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.estimatedRowHeight = 98.0;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _parksArray = [[NSMutableArray alloc] init];
    _postcode = @"you";
    _refreshControl = [[ODRefreshControl alloc] initInScrollView:_tableView];
    [_refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];

    [self startRefreshActivityIndicator];
    [self loadLocation];
}

- (void)refresh:(ODRefreshControl *)refreshControl {
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self loadLocation];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [_optionsTableView reloadData];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)sortParks:(id)sender {
    
    
    
    
    
    
    
}

- (IBAction)gotoMap:(id)sender {
    [self performSegueWithIdentifier:@"map" sender:self];
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
    NSArray *parkList = [self getAllOpenParksWithLocationData];
    NSMutableArray *parksWithinDistance = [[NSMutableArray alloc] init];
    Haversine *haversine = [[Haversine alloc] init];
    for (Park *park in parkList) {
        haversine.lat1 = park.latitude;
        haversine.lon1 = park.longitude;
        haversine.lat2 = location.coordinate.latitude;
        haversine.lon2 = location.coordinate.longitude;
        park.distance = [haversine toMiles];
        if (park.distance <= [[[NSUserDefaults standardUserDefaults] objectForKey:@"searchDistance"] floatValue]) {
            [parksWithinDistance addObject:park];
        }
    }
    NSArray *sortDescriptor = @[[NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES]];
    NSArray *sortedArray = [parksWithinDistance sortedArrayUsingDescriptors:sortDescriptor];
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
        if (coaster.status == 1) {
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
        if (coaster.status == 1) {
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

- (IBAction)sortParksActionSheet:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Sort parks by.." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Distance", @"Name", @"Number of Coasters", nil];
    [actionSheet showInView:self.view];
}


#pragma mark Location Services

- (void)loadLocation {
    self.locationManager = [[CLLocationManager alloc] init];
    //[_mapView removeAnnotations:_mapView.annotations];
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
    _parksArray = resultsArray;
    [_optionsTableView reloadData];
    [_tableView reloadData];
    [_refreshControl endRefreshing];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:_currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!(error)) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            _postcode = placemark.postalCode;
            [_optionsTableView reloadData];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [_locationManager stopUpdatingLocation];
    [_refreshControl endRefreshing];
    [self stopRefreshActivityIndicator];
    //[_mapView removeAnnotations:_mapView.annotations];
    _updateLocationDidFail = YES;
    _error = error;
    [_tableView reloadData];
}


#pragma mark Table View Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _optionsTableView) {
        return 1;
    } else {
        if (_updateLocationDidFail) {
            return 1;
        } else {
            return [_parksArray count];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _optionsTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OptionsCell"];
        NSNumber *searchValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchDistance"];
        if ([searchValue intValue] == 1) {
            cell.textLabel.text = [[NSString alloc] initWithFormat: @"All parks within %@ mile of %@", searchValue, _postcode];
        } else {
            cell.textLabel.text = [[NSString alloc] initWithFormat: @"All parks within %@ miles of %@", searchValue, _postcode];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _optionsTableView) {
        [self performSegueWithIdentifier:@"locationSettings" sender:self];
    } else {
        _selectedPark = [_parksArray objectAtIndex:indexPath.row];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"coastersInPark" sender:self];
        });
    }
}

#pragma mark Core Data

- (NSArray *)getAllOpenParksWithLocationData {
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Park" inManagedObjectContext:coreDataStack.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(status == 1) AND (latitude != 0.0)"];
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
    } else if ([segue.identifier isEqualToString:@"locationSettings"]) {
        
        
        
    } else if ([segue.identifier isEqualToString:@"map"]) {
        HomeMapViewController *mapVC = segue.destinationViewController;
        mapVC.parksArray = _parksArray;
    }
}
- (IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    if ([segue.identifier isEqualToString:@"home"]) {
        [self loadLocation];
    }
}

@end
