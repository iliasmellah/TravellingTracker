//
//  EditTripViewController.swift
//  TravellingTracker
//
//  Created by user154076 on 7/15/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import UIKit

class EditTripViewController: UIViewController {
    
    var trip : TripModel? = nil
    var DEFAULT_COLOR = "#000000"// Black

    override func viewDidLoad() {
        super.viewDidLoad()

        guard (self.trip != nil) else {return}
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation -
    let segueEmbedId = "embedFromEditTripSegue"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.segueEmbedId {
            let embedTripController = segue.destination as! EmbedTripViewController
            embedTripController.trip = self.trip
        }
        
        guard let trip = self.trip else {return}
        guard let embedTripViewController = self.children.first as? EmbedTripViewController else {return}
  
        trip.name = embedTripViewController.tripName.text ?? ""
        trip.color = embedTripViewController.tripColor.text?.colorFromHex() ?? DEFAULT_COLOR.colorFromHex()
        trip.dateStart = Date.toDate(dateString: embedTripViewController.tripStartDate.text!)
        trip.dateEnd = Date.toDate(dateString: embedTripViewController.tripEndDate.text!)
        
        trip.save()
        self.dismiss(animated: true, completion: nil)
    }
}
