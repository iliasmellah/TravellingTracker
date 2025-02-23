//
//  ShowPlaceViewController.swift
//  TravellingTracker
//
//  Created by user154076 on 8/20/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import UIKit

class ShowPlaceViewController: UIViewController {
    
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeAddress: UILabel!
    @IBOutlet weak var placeDate: UILabel!
    @IBOutlet weak var placeLatitude: UILabel!
    @IBOutlet weak var placeLongitude: UILabel!
    @IBOutlet weak var placePicture: UIImageView!
    
    var trip : TripModel? = nil
    var place : PlaceModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.placeName.numberOfLines = 0
        self.placeName.lineBreakMode = .byWordWrapping
        self.placeName.sizeToFit()
        
        if place?.name != "" { self.placeName.text = place?.name } else { self.placeName.text = "No name yet" }
        self.placeAddress.text = place?.address
        self.placeDate.text = Date.toString(date: place!.date)
        self.placeLatitude.text = place?.latitude
        self.placeLongitude.text = place?.longitude
        self.placePicture.image = place?.picture.rotate(radians: .pi/2)
    }
    
    
    @IBAction func deletePlaceButton(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this place ?", preferredStyle: .alert)
        
        // creates OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.place!.delete()
            self.performSegue(withIdentifier: "unwindAfterDeletePlace", sender: self)
        })
        
        // creates Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in }
        
        // adds OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)

        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    // mARK: - Navigation -
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editPlace" {
            let editPlaceViewController = segue.destination as! EditPlaceViewController
            editPlaceViewController.trip = self.trip
            editPlaceViewController.place = self.place
        }
    }

}
