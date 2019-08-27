//
//  FullMapViewController.swift
//  TravellingTracker
//
//  Created by user154076 on 8/23/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import UIKit
import MapKit

class FullMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var trip : TripModel?
    var places : [PlaceModel]? = []
    var placeCenter : PlaceModel? = nil
    
    var latitudeDegrees : CLLocationDegrees = 0.0
    var longitudeDegrees : CLLocationDegrees = 0.0
    var annotationLocations : [[String : Any]] = [[:]]
    let distanceSpan : CLLocationDistance = 50000
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let places = self.places {
            latitudeDegrees = Double(self.placeCenter!.latitude) as! CLLocationDegrees
            longitudeDegrees = Double(self.placeCenter!.longitude) as! CLLocationDegrees
            let centerLocation = CLLocation(latitude: self.latitudeDegrees, longitude: self.longitudeDegrees)
            
            annotationLocations.removeAll()
            for i in 0...places.count-1 {
                annotationLocations.append(["title" : places[i].name, "latitude" : Double(places[i].latitude)!, "longitude" : Double(places[i].longitude)!])
            }
            
            createAnnotations(locations: annotationLocations)
            zoomLevel(location: centerLocation)
        }
    }
    
    // defines map zoom level
    func zoomLevel(location: CLLocation) {
        let mapCoordinates = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: distanceSpan, longitudinalMeters: distanceSpan)
        mapView.setRegion(mapCoordinates, animated: true)
    }
    
    //creates an annotation on the map
    func createAnnotations(locations: [[String : Any]]) {
        for location in locations {
            let annotations = MKPointAnnotation()
            annotations.title = location["title"] as? String
            annotations.coordinate = CLLocationCoordinate2D(latitude: location["latitude"] as! CLLocationDegrees, longitude: location["longitude"] as! CLLocationDegrees)
            mapView.addAnnotation(annotations)
        }
    }
}
