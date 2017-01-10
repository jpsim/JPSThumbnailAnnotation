//
//  ViewController.swift
//  JPSThumbnailAnnotation
//
//  Created by JP Simard on 5/1/15.
//  Copyright (c) 2015 JP Simard. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    var annotations: [JPSThumbnailAnnotation] {
        // Empire State Building
        let empire = JPSThumbnail()
        empire.image = UIImage(named: "empire.jpg")
        empire.title = "Empire State Building"
        empire.subtitle = "NYC Landmark"
        empire.coordinate = CLLocationCoordinate2DMake(40.75, -73.99)
        empire.disclosureBlock = { println("selected Empire") }

        // Apple HQ
        let apple = JPSThumbnail()
        apple.image = UIImage(named: "apple.jpg")
        apple.title = "Apple HQ"
        apple.subtitle = "Apple Headquarters"
        apple.coordinate = CLLocationCoordinate2DMake(37.33, -122.03)
        apple.disclosureBlock = { println("selected Apple") }

        // Parliament of Canada
        let ottawa = JPSThumbnail()
        ottawa.image = UIImage(named: "ottawa.jpg")
        ottawa.title = "Parliament of Canada"
        ottawa.subtitle = "Oh Canada!"
        ottawa.coordinate = CLLocationCoordinate2DMake(45.43, -75.70)
        ottawa.disclosureBlock = { println("selected Ottawa") }

        return [empire, apple, ottawa].map {
            JPSThumbnailAnnotation(thumbnail: $0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Map View
        let mapView = MKMapView(frame: view.bounds)
        mapView.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        mapView.delegate = self
        view.addSubview(mapView)

        // Annotations
        mapView.addAnnotations(annotations)
    }

    // MARK: MKMapViewDelegate

    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        (view as? JPSThumbnailAnnotationViewProtocol)?.didSelectAnnotationViewInMap(mapView)
    }

    func mapView(mapView: MKMapView!, didDeselectAnnotationView view: MKAnnotationView!) {
        (view as? JPSThumbnailAnnotationViewProtocol)?.didDeselectAnnotationViewInMap(mapView)
    }

    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        return (annotation as? JPSThumbnailAnnotationProtocol)?.annotationViewInMap(mapView)
    }
}
