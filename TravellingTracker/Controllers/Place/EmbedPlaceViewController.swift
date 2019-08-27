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

class EmbedPlaceViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeDate: UITextField!
    @IBOutlet weak var placePicture: UIImageView!
    @IBOutlet weak var placeAddress: UILabel!
    @IBOutlet weak var placeLatitude: UILabel!
    @IBOutlet weak var placeLongitude: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var latitudePhoto: CLLocationDegrees? = 0.0
    var longitudePhoto: CLLocationDegrees? = 0.0
    var distanceSpan: CLLocationDistance = 5000
    var addressString = ""
    
    let locationManager = CLLocationManager()
    let regionInMeters = 1000
    var previousLocation: CLLocation?
    
    var trip : TripModel?
    var place: PlaceModel?
    
    private var datePicker:UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationServices()
        
        if let place = self.place {
            self.placeName.text = place.name
            self.placeDate.text = Date.toString(date: place.date)
            self.placePicture.image = place.picture.rotate(radians: .pi/2)
            self.placeAddress.text = place.address
            self.placeLatitude.text = place.latitude
            self.placeLongitude.text = place.longitude
            
            let latitudeDegrees : CLLocationDegrees = Double(place.latitude) as! CLLocationDegrees
            let longitudeDegrees : CLLocationDegrees = Double(place.longitude) as! CLLocationDegrees
            
            let locationInit : CLLocation = CLLocation.init(latitude: latitudeDegrees, longitude: longitudeDegrees)
            
            let center = CLLocationCoordinate2D(latitude: locationInit.coordinate.latitude, longitude: locationInit.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: true)
        } else {
            self.placeAddress.text = "Please choose a picture or location"
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EmbedPlaceViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.date = place?.date ?? Date.currentDate()
        datePicker?.addTarget(self, action: #selector(EmbedPlaceViewController.dateChanged(datePicker:)), for: .valueChanged)
        placeDate.inputView = datePicker
        placeDate.inputAccessoryView = createToolBar()
    }
    
    //Add top tool bar to the date picker
    func createToolBar() -> UIToolbar {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed(sender:)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBar.setItems([flexibleSpace,doneButton, flexibleSpace], animated: true)
        return toolBar
    }
    
    @objc func doneButtonPressed(sender: UIBarButtonItem) {
        placeDate.resignFirstResponder()
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        //Gets data with Date format
        placeDate.text = Date.toString(date: datePicker.date)
        if (datePicker.date < trip!.dateStart) || (datePicker.date > trip!.dateEnd) {
            datePicker.date = trip!.dateStart
            placeDate.text = Date.toString(date: trip!.dateStart)
        }
    }
    
    @IBAction func addPicture(_ sender: Any) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            self.displayImagePicker()
        case .notDetermined:
            print("Permission Not Determined")
            PHPhotoLibrary.requestAuthorization({ (status) in })
        default:
            break
        }
    }
    
    func displayImagePicker() {
        let alert = UIAlertController(title: "Update your photo", message: "Please select an option", preferredStyle: .actionSheet)
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        alert.addAction(UIAlertAction(title: "Take a new photo", style: .default , handler:{ (UIAlertAction)in
            self.presentUIImagePicker(sourceType: .camera)
        }))
        
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default , handler:{ (UIAlertAction)in
            self.presentUIImagePicker(sourceType: .photoLibrary)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func presentUIImagePicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true, completion: nil)
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
            
            if (self.latitudePhoto == nil || self.longitudePhoto == nil) {
                self.placeAddress.text = "This picture has no location information"
                self.placeLatitude.text = "none"
                self.placeLongitude.text = "none"
            } else {
                let centerLocation = CLLocation(latitude: self.latitudePhoto!, longitude: self.longitudePhoto!)
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
                        self.zoomLevel(location: centerLocation)
                    } else {
                        print("error")
                    }
                }
            }
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func zoomLevel(location: CLLocation) {
        let mapCoordinates = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: distanceSpan, longitudinalMeters: distanceSpan)
        
        mapView.setRegion(mapCoordinates, animated: true)
    }
    
    func checkLocationServices() {
        setupLocationManager()
        startTrackingUserLocation()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.delegate = self
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: CLLocationDistance(regionInMeters), longitudinalMeters: CLLocationDistance(regionInMeters))
            mapView.setRegion(region, animated: true)
            self.placeAddress.text = "Please choose a location"
        }
    }
    
    func startTrackingUserLocation() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    // MARK : - TextField Delegate -
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension EmbedPlaceViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
}

extension EmbedPlaceViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        //check if previous location is not too close or same as from the current
        guard let previousLocation = self.previousLocation else {return}
        guard center.distance(from: previousLocation) > 1 else {return}
        self.previousLocation = center
        
        geoCoder.reverseGeocodeLocation(center) {
            [weak self] (placemarks,error) in
            guard let self = self else {return}
            if let _ = error {
                return
            }
            
            guard let placemark = placemarks?.first else {
                return
            }
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            let cityName = placemark.locality ?? ""
            let lat = placemark.location?.coordinate.latitude
            let long = placemark.location?.coordinate.longitude
            
            //displays coordinates
            self.placeLatitude.text = "\(String(describing: lat!))"
            self.placeLongitude.text = "\(String(describing: long!))"
            
            // displays address if found one from the coordinates
            if (streetName == "" || cityName == "") {
                self.placeAddress.text = "No address found for this location"
            } else {
                self.placeAddress.text = streetNumber + " " + streetName + " " + cityName.uppercased()
            }
        }
    }
}
