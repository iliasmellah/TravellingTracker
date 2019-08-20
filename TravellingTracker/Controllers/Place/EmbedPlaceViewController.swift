//
//  EmbedPlaceViewController.swift
//  TravellingTracker
//
//  Created by user154076 on 8/19/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import AssetsLibrary
import Photos

class EmbedPlaceViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeDate: UITextField!
    @IBOutlet weak var placePicture: UIImageView!
    @IBOutlet weak var placeAddress: UILabel!
    @IBOutlet weak var placeLatitude: UILabel!
    @IBOutlet weak var placeLongitude: UILabel!
    
    var latitudePhoto: CLLocationDegrees? = 0.0
    var longitudePhoto: CLLocationDegrees? = 0.0
    var distanceSpan: CLLocationDistance = 5000
    var addressString = ""
    
    let locationManager = CLLocationManager()
    let regionInMeters = 10000
    var previousLocation: CLLocation?
    
    var trip : TripModel?
    var place: PlaceModel?
    
    private var datePicker:UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let place = self.place {
            self.placeName.text = place.name
            self.placeDate.text = Date.toString(date: place.date)
        } else {
            self.placeAddress.text = "Please choose a picture"
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EmbedPlaceViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(EmbedPlaceViewController.dateChanged(datePicker:)), for: .valueChanged)
        placeDate.inputView = datePicker
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        //Gets data with Date format
        placeDate.text = Date.toString(date: datePicker.date)
        view.endEditing(true)
    }
    
    @IBAction func addPicture(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let alert = UIAlertController(title: "Add a photo", message: "Please select an option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take a new photo", style: .default , handler:{ (UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("No camera available")
            }
        }))
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default , handler:{ (UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            placePicture.image = image
           
        }
        
        if let URL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
            let opts = PHFetchOptions()
            opts.fetchLimit = 1
            let assets = PHAsset.fetchAssets(withALAssetURLs: [URL], options: opts)
            let asset = assets[0]
            
            self.latitudePhoto = asset.location?.coordinate.latitude
            self.longitudePhoto = asset.location?.coordinate.longitude
            
            //let centerLocation = CLLocation(latitude: self.latitudePhoto!, longitude: self.longitudePhoto!)
            
            if (self.latitudePhoto == nil || self.longitudePhoto == nil) {
                self.placeAddress.text = "This picture has no location information"
                self.placeLatitude.text = "none"
                self.placeLongitude.text = "none"
            } else {
                let loc = CLLocation(latitude: self.latitudePhoto!, longitude: self.longitudePhoto!)
            
                CLGeocoder().reverseGeocodeLocation(loc) { (placemarks, error) in
                    if error != nil {
                        print("failed")
                        return
                    }
                    if (placemarks?.count)! > 0 {
                        let ruePhoto = placemarks?[0].thoroughfare ?? "Rue"
                        let villePhoto = placemarks?[0].locality?.uppercased() ?? "City"
                        let paysPhoto = placemarks?[0].country?.uppercased() ?? "Country"
                        self.addressString = (ruePhoto + " " + villePhoto + ", " + paysPhoto)
                        self.placeAddress.text = self.addressString
                        self.placeLatitude.text = "\(String(describing: self.latitudePhoto!))"
                        self.placeLongitude.text = "\(String(describing: self.longitudePhoto!))"
                        
                        /*let annotationLocation = [
                            "title": self.addressString, "latitude" : self.latitudePhoto as Any, "longitude" : self.longitudePhoto as Any
                            ] as [String : Any]
                        
                        self.createAnnotation(location: annotationLocation as [String : Any])
                        self.zoomLevel(location: centerLocation)*/
                    } else {
                        print("error")
                    }
                }
            }
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    /*func zoomLevel(location: CLLocation) {
        let mapCoordinates = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: distanceSpan, longitudinalMeters: distanceSpan)
        
        mapView.setRegion(mapCoordinates, animated: true)
    }
    
    func createAnnotation(location: [String : Any]) {
        let annotation = MKPointAnnotation()
        annotation.title = (location["title"] as! String)
        annotation.coordinate = CLLocationCoordinate2D(latitude: location["latitude"] as! CLLocationDegrees, longitude: location["longitude"] as! CLLocationDegrees)
        
        mapView.addAnnotation(annotation)
    }
    
    func checkLocationServices() {
        setupLocationManager()
        startTrackingUserLocation()
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
            self.placeAddress.text = "Please choose a location"
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
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        print("latitude :", latitude)
        print("longitude :", longitude, "\n")
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }*/
    
    // MARK : - TextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

/*extension EmbedPlaceViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //startTrackingUserLocation()
    }
}

extension EmbedPlaceViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        //check if previous location is not too close from the current
        guard let previousLocation = self.previousLocation else {return}
        guard center.distance(from: previousLocation) > 1 else {return}
        self.previousLocation = center
        
        geoCoder.reverseGeocodeLocation(center) {
            [weak self] (placemarks,error) in
            guard let self = self else {return}
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
            print("Adresse : ", streetNumber, " ", streetName)
            if (streetName == "" || cityName == "") {
                self.placeAddress.text = "No address found for this location"
            } else {
                self.placeAddress.text = streetNumber + " " + streetName + " " + cityName.uppercased()
            }
            //}
        }
    }
}*/
