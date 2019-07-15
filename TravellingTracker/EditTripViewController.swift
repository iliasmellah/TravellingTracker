//
//  EditTripViewController.swift
//  TravellingTracker
//
//  Created by user154076 on 7/15/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import UIKit

class EditTripViewController: UIViewController {
    
    var trip : Trip? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        guard (self.trip != nil) else {return}
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveAction))
    }
    

    
    // MARK: - Navigation
     
    let segueEmbedId = "embedFromEditTripSegue"
    let segueUnwindId = "unwindToTripViewControllerFromEditing"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.segueEmbedId {
            let embedTripController = segue.destination as! EmbedTripViewController
            embedTripController.trip = self.trip
        }
    }
    
    // MARK: - Save -
    
    @IBAction func saveAction(sender: UIBarButtonItem) {
        guard let trip = self.trip else {return}
        let editTripController = self.children[0] as! EmbedTripViewController
        guard (editTripController.tripName.text != "" || editTripController.tripColor.text != "") else {
            alert(WithTitle: "I need at least the name and color of your trip", andMessage: "")
            return
        }
        trip.name = editTripController.tripName.text
        trip.color = editTripController.tripColor.text
        trip.dateStart = editTripController.tripStartDateReal
        trip.dateEnd = editTripController.tripEndDateReal
        self.performSegue(withIdentifier: self.segueUnwindId, sender: self)
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
