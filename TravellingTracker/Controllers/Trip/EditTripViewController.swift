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
    var DEFAULT_COLOR = "#000000"

    override func viewDidLoad() {
        super.viewDidLoad()

        guard (self.trip != nil) else {return}
    }
    
    // MARK: - Navigation
     
    let segueEmbedId = "embedFromEditTripSegue"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.segueEmbedId {
            let embedTripController = segue.destination as! EmbedTripViewController
            embedTripController.trip = self.trip
        }
        
        guard let trip = self.trip else {return}
        guard let embedTripViewController = self.children.first as? EmbedTripViewController else {return}
        
        /*guard (embedTripViewController.tripName.text != "") else {
            alert(WithTitle: "I need at least the name of your trip", andMessage: "XX")
            return
        }*/
        trip.name = embedTripViewController.tripName.text ?? ""
        trip.color = embedTripViewController.tripColor.text?.colorFromHex() ?? DEFAULT_COLOR.colorFromHex()
        trip.dateStart = Date.toDate(dateString: embedTripViewController.tripStartDate.text!)
        trip.dateEnd = Date.toDate(dateString: embedTripViewController.tripEndDate.text!)
        
        trip.save()
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Cancel and Save -
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Helper Methods
    func alert(WithTitle title : String, andMessage msg : String = "") {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
