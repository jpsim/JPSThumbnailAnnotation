//
//  ViewController.m
//  JPSThumbnailAnnotationView
//
//  Created by Jean-Pierre Simard on 4/21/13.
//  Copyright (c) 2013 JP Simard. All rights reserved.
//

@import MapKit;
#import "ViewController.h"
#import "JPSThumbnailAnnotation.h"

@interface ViewController () <MKMapViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Map View
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mapView.delegate = self;
    [self.view addSubview:mapView];
    
    // Annotations
    [mapView addAnnotations:[self annotations]];
}

- (NSArray *)annotations {
    // Empire State Building
    JPSThumbnail *empire = [[JPSThumbnail alloc] init];
    empire.image = [UIImage imageNamed:@"empire.jpg"];
    empire.title = @"Empire State Building";
    empire.subtitle = @"NYC Landmark";
    empire.coordinate = CLLocationCoordinate2DMake(40.75f, -73.99f);
    empire.disclosureBlock = ^{ NSLog(@"selected Empire"); };
    
    // Apple HQ
    JPSThumbnail *apple = [[JPSThumbnail alloc] init];
    apple.image = [UIImage imageNamed:@"apple.jpg"];
    apple.title = @"Apple HQ";
    apple.subtitle = @"Apple Headquarters";
    apple.coordinate = CLLocationCoordinate2DMake(37.33f, -122.03f);
    apple.disclosureBlock = ^{ NSLog(@"selected Appple"); };
    
    // Parliament of Canada
    JPSThumbnail *ottawa = [[JPSThumbnail alloc] init];
    ottawa.image = [UIImage imageNamed:@"ottawa.jpg"];
    ottawa.title = @"Parliament of Canada";
    ottawa.subtitle = @"Oh Canada!";
    ottawa.coordinate = CLLocationCoordinate2DMake(45.43f, -75.70f);
    ottawa.disclosureBlock = ^{ NSLog(@"selected Ottawa"); };
    
    // Web Image Example
    // Seattle Space Needle Building
    JPSThumbnail *spaceNeedle = [[JPSThumbnail alloc] init];
    NSString *stringUrl =  @"https://upload.wikimedia.org/wikipedia/commons/2/23/Space_Needle_2011-07-04.jpg"; // Non-squared big image
    spaceNeedle.imageUrl = [NSURL URLWithString:stringUrl]; // Set web image from url
    spaceNeedle.contentMode = UIViewContentModeScaleAspectFit; // Set image Aspect to see all image
    spaceNeedle.title = @"Space Needle";
    spaceNeedle.subtitle = @"Seattle Landmark";
    spaceNeedle.coordinate = CLLocationCoordinate2DMake(47.6205f, -122.3493f);
    spaceNeedle.disclosureBlock = ^{ NSLog(@"selected Space Needle"); };
    
    return @[[JPSThumbnailAnnotation annotationWithThumbnail:empire],
             [JPSThumbnailAnnotation annotationWithThumbnail:apple],
             [JPSThumbnailAnnotation annotationWithThumbnail:ottawa],
             [JPSThumbnailAnnotation annotationWithThumbnail:spaceNeedle]];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didSelectAnnotationViewInMap:mapView];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didDeselectAnnotationViewInMap:mapView];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation conformsToProtocol:@protocol(JPSThumbnailAnnotationProtocol)]) {
        return [((NSObject<JPSThumbnailAnnotationProtocol> *)annotation) annotationViewInMap:mapView];
    }
    return nil;
}

@end
