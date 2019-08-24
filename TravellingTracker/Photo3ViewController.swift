//
//  Photo3ViewController.swift
//  TravellingTracker
//
//  Created by user154076 on 7/30/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import AssetsLibrary
import Photos

class Photo3ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var latitudePhoto: CLLocationDegrees? = 0.0
    var longitudePhoto: CLLocationDegrees? = 0.0
    var distanceSpan: CLLocationDistance = 5000
    var addressString = "City,Country"

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func addPhoto(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let alert = UIAlertController(title: "Update your photo", message: "Please select an option", preferredStyle: .actionSheet)
        
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
            imageView.image = image
        }
        
//        if let URL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
//            let opts = PHFetchOptions()
//            opts.fetchLimit = 1
//            let assets = PHAsset.fetchAssets(withALAssetURLs: [URL], options: opts)
//            let asset = assets[0]
//            
//            self.latitudePhoto = asset.location?.coordinate.latitude
//            self.longitudePhoto = asset.location?.coordinate.longitude
//            
//            let centerLocation = CLLocation(latitude: self.latitudePhoto!, longitude: self.longitudePhoto!)
//        
//            
//            
//            let loc = CLLocation(latitude: self.latitudePhoto!, longitude: self.longitudePhoto!)
//            
//            CLGeocoder().reverseGeocodeLocation(loc) { (placemarks, error) in
//                if error != nil {
//                    print("failed")
//                    return
//                }
//                if (placemarks?.count)! > 0 {
//                    
//                    let villePhoto = placemarks?[0].locality ?? "VILLE"
//                    let paysPhoto = placemarks?[0].country ?? "PAYS"
//                    
//                    self.addressString = (villePhoto + "," + paysPhoto)
//                    
//                    print("\nADDRESS STRING : \n" + self.addressString + "\n")
//                    
//                    let annotationLocation = [
//                        "title": self.addressString, "latitude" : self.latitudePhoto as Any, "longitude" : self.longitudePhoto as Any
//                        ] as [String : Any]
//                    
//                    self.createAnnotation(location: annotationLocation as [String : Any])
//                    self.zoomLevel(location: centerLocation)
//                    
//                } else {
//                    print("error")
//                }
//            }
//            
//          
//            
        }
        
        picker.dismiss(animated: true, completion: nil)
   }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func zoomLevel(location: CLLocation) {
        let mapCoordinates = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: distanceSpan, longitudinalMeters: distanceSpan)
        
        mapView.setRegion(mapCoordinates, animated: true)
    }
    
    func createAnnotation(location: [String : Any]) {
        let annotation = MKPointAnnotation()
        annotation.title = (location["title"] as! String)
        annotation.coordinate = CLLocationCoordinate2D(latitude: location["latitude"] as! CLLocationDegrees, longitude: location["longitude"] as! CLLocationDegrees)
        
        mapView.addAnnotation(annotation)
    }
    
    func lookUpCurrentLocation(location : CLLocation?, completionHandler: @escaping (CLPlacemark?) -> Void ) {
        // Use the last reported location.
        if let lastLocation = location {
            let geocoder = CLGeocoder()
            
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation, completionHandler:
                { (placemarks, error) in
                    if error == nil {
                        let firstLocation = placemarks?[0]
                        completionHandler(firstLocation)
                        print("PLAAAAAAACE : ", firstLocation as Any)
                    } else {
                        // An error occurred during geocoding.
                        completionHandler(nil)
                    }
            }
            )
        } else {
            // No location was available.
            completionHandler(nil)
        }
    }
}


