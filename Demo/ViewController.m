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
    
    // Sagrada Familia
    JPSThumbnail *barcelona = [[JPSThumbnail alloc] init];
    barcelona.imageURL = @"https://www.shbarcelona.es/blog/es/wp-content/uploads/2015/10/gaudi-en-barcelona-3-768x741.jpg";
    barcelona.title = @"Sagrada Familia";
    barcelona.subtitle = @"Barcelona";
    barcelona.coordinate = CLLocationCoordinate2DMake(41.4036f, 2.1744f);
    barcelona.disclosureBlock = ^{ NSLog(@"selected Barcelona"); };
    
    //Switzerland mountains
    JPSThumbnail *switzerland = [[JPSThumbnail alloc] init];
    switzerland.imageURL = @"https://pbs.twimg.com/media/CkXS4erWEAA5J3b.jpg";
    switzerland.contentMode = UIViewContentModeScaleAspectFit; // By default Aspect fill
    switzerland.title = @"Switzerland";
    switzerland.subtitle = @"Mountains";
    switzerland.coordinate = CLLocationCoordinate2DMake(47.3769f, 8.5417f);
    switzerland.disclosureBlock = ^{ NSLog(@"selected Barcelona"); };
    
    return @[[JPSThumbnailAnnotation annotationWithThumbnail:empire],
             [JPSThumbnailAnnotation annotationWithThumbnail:apple],
             [JPSThumbnailAnnotation annotationWithThumbnail:ottawa],
             [JPSThumbnailAnnotation annotationWithThumbnail:barcelona],
             [JPSThumbnailAnnotation annotationWithThumbnail:switzerland]];
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
