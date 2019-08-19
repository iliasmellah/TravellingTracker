//
//  CreatePlaceViewController.swift
//  TravellingTracker
//
//  Created by user154076 on 8/19/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import UIKit

class CreatePlaceViewController: UIViewController {
    
    var trip : TripModel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cancelPlace(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    let segueEmbedId = "embedFromNewPlaceSegue"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.segueEmbedId {
            let embedPlaceController = segue.destination as! EmbedPlaceViewController
            embedPlaceController.trip = trip 
        }
        
        guard let embedPlaceViewController = self.children.first as? EmbedPlaceViewController else {return}
        
        let name: String = embedPlaceViewController.placeName.text ?? ""
        let date: Date = Date.toDate(dateString: embedPlaceViewController.placeDate.text!)
        
        guard (name != "") else {return}
        
        //crée un nouveau Trip Managed Object
        let place = PlaceModel(name: name, date: date, trip: trip)
        place.save()
        
        self.dismiss(animated: true, completion: nil)
    }

}
