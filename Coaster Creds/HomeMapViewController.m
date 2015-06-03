//
//  HomeMapViewController.m
//  Coaster Creds
//
//  Created by Mike Fudge on 20/05/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import "HomeMapViewController.h"
#import <MapKit/MapKit.h>
#import "Park.h"
#import "ParkPinAnnotationView.h"
#import "ParkPointAnnotation.h"
#import "CoasterViewController.h"

@interface HomeMapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) Park *selectedPark;

@end

@implementation HomeMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_mapView setDelegate:self];
    [self addAnnotationsToMap:_mapView fromArray:_parksArray];
    [self zoomToFitMapAnnotations:_mapView withPadding:1.2];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [_mapView removeAnnotations:_mapView.annotations];
    [self addAnnotationsToMap:_mapView fromArray:_parksArray];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) return nil;
    
    Park *park = ((ParkPointAnnotation *)annotation).park;
    ParkPinAnnotationView *annotationView = [[ParkPinAnnotationView alloc] initWithAnnotation:annotation park:park];
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
        ParkPointAnnotation *annotation = [[ParkPointAnnotation alloc] init];
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(park.latitude, park.longitude);
        annotation.coordinate = coord;
        annotation.park = park;
        annotation.title = park.name;
        annotation.subtitle = [NSString stringWithFormat:@"%.2f mi away", park.distance];
        [mapView addAnnotation:annotation];
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(ParkPinAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    if ([view.annotation isKindOfClass:[MKUserLocation class]]) return;
    _selectedPark = view.park;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"coastersInPark" sender:self];
    });
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"coastersInPark"]) {
        CoasterViewController *coasterTableViewController = segue.destinationViewController;
        coasterTableViewController.hidesBottomBarWhenPushed = YES;
        coasterTableViewController.park = _selectedPark;
    }
}

@end
