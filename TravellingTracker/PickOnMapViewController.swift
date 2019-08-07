//
//  PickOnMapViewController.swift
//  TravellingTracker
//
//  Created by user154076 on 8/4/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PickOnMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!

    let locationManager = CLLocationManager()
    let regionInMeters = 10000
    
    var previousLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationServices()
    }
    
    func checkLocationServices() {
        //if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            startTrackingUserLocation()
        //}
    }
    
    func setupLocationManager() {
        print("setupLocationManager\n")
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.delegate = self
        
    }
    
    func centerViewOnUserLocation() {
        print("centerViewOnUser")
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: CLLocationDistance(regionInMeters), longitudinalMeters: CLLocationDistance(regionInMeters))
            mapView.setRegion(region, animated: true)
        }
    }
    
    func startTrackingUserLocation() {
        print("startTracking\n")
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        print("getCenterLocation")
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        print("latitude :", latitude)
        print("longitude :", longitude, "\n")
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}

extension PickOnMapViewController: CLLocationManagerDelegate {    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //startTrackingUserLocation()
    }
}

extension PickOnMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        print("poooooooooo")
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("mapView extension\n")
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        //check if previous location is not too close from the current
        guard let previousLocation = self.previousLocation else {return}
        guard center.distance(from: previousLocation) > 50 else {return}
        self.previousLocation = center
            
        geoCoder.reverseGeocodeLocation(center) {
            [weak self] (placemarks,error) in
            guard let self = self else {return}
            print("geocoder\n")
            if let _ = error {
                //How alert to user
                return
            }
            
            guard let placemark = placemarks?.first else {
                return
            }
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            let cityName = placemark.locality ?? ""
            
            //DispatchQueue.main.sync {
                print("UUUUUUUUUUUUUUUUU : ", streetNumber, " ", streetName)
                self.addressLabel.text = streetNumber + ", " + streetName + " " + cityName.uppercased()
            //}
        }
    }
}
