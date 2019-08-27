//
//  EditPlaceViewController.swift
//  TravellingTracker
//
//  Created by user154076 on 8/20/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import UIKit

class EditPlaceViewController: UIViewController {
    
    var trip: TripModel? = nil
    var place: PlaceModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation -
    let segueEmbedId = "embedFromEditPlaceSegue"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.segueEmbedId {
            let embedPlaceController = segue.destination as! EmbedPlaceViewController
            embedPlaceController.trip = self.trip
            embedPlaceController.place = self.place
        }
        
        guard (self.trip != nil || self.place != nil) else {return}
        guard let embedPlaceViewController = self.children.first as? EmbedPlaceViewController else {return}
        
        place?.name = embedPlaceViewController.placeName.text ?? "No name yet"
        place?.date = Date.toDate(dateString: embedPlaceViewController.placeDate.text!)
        place?.picture = embedPlaceViewController.placePicture.image ?? UIImage(named: "placeholder")!
        place?.address = embedPlaceViewController.placeAddress.text ?? "No address found for this location"
        place?.latitude = embedPlaceViewController.placeLatitude.text ?? "0"
        place?.longitude = embedPlaceViewController.placeLongitude.text ?? "0"
        
        place?.save()
        self.dismiss(animated: true, completion: nil)
    }

}
