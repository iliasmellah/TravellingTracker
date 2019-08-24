//
//  PhotoMapViewController.swift
//  TravellingTracker
//
//  Created by user154076 on 7/21/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import UIKit
import Photos
import AssetsLibrary
import MapKit

class PhotoMapViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func importImage(_ sender: Any) {
        /*
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        
        self.present(image, animated: true) {
            //after it is complete
            print("Completed")
        }
 */
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
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
        
//        if let URL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
//            let opts = PHFetchOptions()
//            opts.fetchLimit = 1
//            let assets = PHAsset.fetchAssets(withALAssetURLs: [URL], options: opts)
//            let asset = assets[0]
//            print("\n Latitude : \n", asset.location?.coordinate.latitude as Any)
//            print("\n Longitude : \n", asset.location?.coordinate.longitude as Any)
//            
//            //let latitudePhoto = asset.location?.coordinate.latitude
//            //let longitudePhoto = asset.location?.coordinate.longitude
//        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLocationServices()
        // Do any additional setup after loading the view.
    }
    
    // - MARK : Map Tests -
    private let locationManager = CLLocationManager()
    private var currentCoordinate : CLLocationCoordinate2D?
    
    private func configureLocationServices() {
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else if (status == .authorizedAlways || status == .authorizedWhenInUse) {
            beginLocationUpdates(locationManager: locationManager)
        }
    }
    
    private func beginLocationUpdates(locationManager: CLLocationManager) {
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    private func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D) {
        let zoomRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(zoomRegion, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func (for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PhotoMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location reçue")
        
        // - MARK : Localiser polytech à l'initialisation -
        //let latitudeString : String = "43.63277"
        //let longitudeString : String = "3.8626449"
        
        //let latitudeDegrees : CLLocationDegrees = Double(latitudeString) as! CLLocationDegrees
        //let longitudeDegrees : CLLocationDegrees = Double(longitudeString) as! CLLocationDegrees
        
        //let locationPolytech : CLLocation = CLLocation.init(latitude: latitudeDegrees, longitude: longitudeDegrees)
       
//        let center = CLLocationCoordinate2D(latitude: locationPolytech.coordinate.latitude, longitude: locationPolytech.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//        mapView.setRegion(region, animated: true)
        
        /*
         guard let latestLocation = locations.first else {return}

        if currentCoordinate == nil {
            zoomToLatestLocation(with: latestLocation.coordinate)
        }
        
        currentCoordinate = latestLocation.coordinate
 */
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Statut changé : ", status)
        if (status == .authorizedAlways || status == .authorizedWhenInUse) {
            beginLocationUpdates(locationManager: manager)
        } else {
            print("pas le droit")
        }
    }
}
