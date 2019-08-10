//
//  CreateTripViewController.swift
//  TravellingTracker
//
//  Created by user154076 on 7/10/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import UIKit

class CreateTripViewController: UIViewController, UITextFieldDelegate {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK : - TextField Delegate -
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK : - CREATE & SAVE A TRIP
    @IBAction func cancelTrip(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    // MARK: - Navigation -
    
    let segueEmbedId = "embedFromNewTripSegue"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.segueEmbedId {
            let embedTripController = segue.destination as! EmbedTripViewController
            embedTripController.trip = nil
        }
        
        print ("Avant le guard")
        guard let embedTripViewController = self.children.first as? EmbedTripViewController else {return}
        
        let name: String = embedTripViewController.tripName.text ?? ""
        let color: String = embedTripViewController.tripColor.text ?? ""
        let dateStart: Date = Date.toDate(dateString: embedTripViewController.tripStartDate.text!)
        let dateEnd: Date = Date.toDate(dateString: embedTripViewController.tripEndDate.text!)
        
        guard (name != "") else {return}
        
        //crée un nouveau Trip Managed Object
        let trip = TripModel(name: name, dateStart: dateStart, dateEnd: dateEnd, color: color.colorFromHex())
        print("saveAction")
        trip.save()
        
        self.dismiss(animated: true, completion: nil)
    }
   /*

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
