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

@interface HomeMapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation HomeMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addAnnotationsToMap:_mapView fromArray:_parksArray];
    [self zoomToFitMapAnnotations:_mapView withPadding:1.2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
