//
//  Map2ViewController.swift
//  TravellingTracker
//
//  Created by user154076 on 7/30/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import UIKit
import MapKit

class Map2ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createAnnotations(locations: annotationLocations)
        zoomLevel(location: centerLocation)
    }
    
    let centerLocation = CLLocation(latitude: -8.6359443, longitude: 115.2141756)
    
    let distanceSpan: CLLocationDistance = 50000
    
    func zoomLevel(location: CLLocation) {
        let mapCoordinates = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: distanceSpan, longitudinalMeters: distanceSpan)
        
        mapView.setRegion(mapCoordinates, animated: true)
    }
    
    let annotationLocations = [
        ["title":"Ubud", "latitude": -8.5068198, "longitude": 115.2623937],
        ["title":"Sanur", "latitude": -8.6998509, "longitude": 115.2652945],
        ["title":"Kuta", "latitude": -8.7184930, "longitude": 115.1710809]
    ]
    

    func createAnnotations(locations: [[String : Any]]) {
        for location in locations {
            let annotations = MKPointAnnotation()
            annotations.title = location["title"] as? String
            annotations.coordinate = CLLocationCoordinate2D(latitude: location["latitude"] as! CLLocationDegrees, longitude: location["longitude"] as! CLLocationDegrees)
            
            mapView.addAnnotation(annotations)
        }
    }
}
