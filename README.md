# JPSThumbnailAnnotation

JPSThumbnailAnnotation is a simple mapkit annotation view for displaying images with clean design and animations. It is 100% programmatically drawn and styled for iOS 7. It supports both local and Web images.

![JPSThumbnailAnnotation in action](screenshots2.jpg)

## Installation

### From CocoaPods

Add `pod 'JPSThumbnailAnnotation'` to your Podfile.

### Manually

Copy the `JPSThumbnailAnnotation` folder to your Xcode project and link the `MapKit`, `QuartzCore` and `CoreLocation` libraries.

## Usage

(see sample Xcode project in `/Demo`)

You add an `JPSThumbnailAnnotation` just like any other `MKAnnotation`. The annotations take in a `JPSThumbnail` object to display an image, title, subtitle at a specific coordinate. You can also set a block to be run when the disclosure button is tapped.

``` objc
JPSThumbnail *thumbnail = [[JPSThumbnail alloc] init];
thumbnail.image = [UIImage imageNamed:@"empire.jpg"];
thumbnail.title = @"Empire State Building";
thumbnail.subtitle = @"NYC Landmark";
thumbnail.coordinate = CLLocationCoordinate2DMake(40.75f, -73.99f);
thumbnail.disclosureBlock = ^{ NSLog(@"selected Empire"); };

[mapView addAnnotation:[JPSThumbnailAnnotation annotationWithThumbnail:thumbnail]];
```

Additionally, you can display Web images, by simply leaving the image property set to nil when creating the JPSThumbnail instances, and providing an imageURL instead.

``` objc
// Central Park -- (Web image Example by using imageURL parameter)
    JPSThumbnail *cPark = [[JPSThumbnail alloc] init];
    cPark.imageURL = [NSURL URLWithString:@"http://insidenanabreadshead.files.wordpress.com/2011/01/ynp-yellowstone-entry-sign.jpg"];
    cPark.title = @"Yellowstone National Park";
    cPark.subtitle = @"Wonders of Nature";
    cPark.coordinate = CLLocationCoordinate2DMake(44.427844f, -110.588519f);
    cPark.disclosureBlock = ^{ NSLog(@"selected Yellowstone Park"); };
```

### Usage notes

Make sure the mapView implements the following 3 MKMapViewDelegate methods:

``` objc
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
```

### Dependencies
This class uses SDWebImage by means of the popular category "UIImageView+UIActivityIndicatorForSDWebImage.h" to allow Web image downloads
 

## License

MIT Licensed.
