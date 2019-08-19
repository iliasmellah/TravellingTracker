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
    @IBOutlet weak var mapView: MKMapView!
    
    var latitudePhoto: CLLocationDegrees? = 0.0
    var longitudePhoto: CLLocationDegrees? = 0.0
    var distanceSpan: CLLocationDistance = 5000
    var addressString = ""
    
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
            
            let centerLocation = CLLocation(latitude: self.latitudePhoto!, longitude: self.longitudePhoto!)
            
            let loc = CLLocation(latitude: self.latitudePhoto!, longitude: self.longitudePhoto!)
            
            CLGeocoder().reverseGeocodeLocation(loc) { (placemarks, error) in
                if error != nil {
                    print("failed")
                    return
                }
                if (placemarks?.count)! > 0 {
                    let villePhoto = placemarks?[0].locality ?? "VILLE"
                    let paysPhoto = placemarks?[0].country ?? "PAYS"
                    self.addressString = (villePhoto + ", " + paysPhoto)
                    self.placeAddress.text = self.addressString
                    
                    let annotationLocation = [
                        "title": self.addressString, "latitude" : self.latitudePhoto as Any, "longitude" : self.longitudePhoto as Any
                        ] as [String : Any]
                    
                    self.createAnnotation(location: annotationLocation as [String : Any])
                    self.zoomLevel(location: centerLocation)
                } else {
                    print("error")
                }
            }
            picker.dismiss(animated: true, completion: nil)
        }
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
    
    // MARK : - TextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


}
