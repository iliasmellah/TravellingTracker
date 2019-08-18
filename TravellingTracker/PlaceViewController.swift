//
//  PlaceViewController.swift
//  TravellingTracker
//
//  Created by user154076 on 7/31/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import UIKit

class PlaceViewController: UIViewController {
    
    @IBOutlet weak var placesCollection: UICollectionView!
    
    var trip : TripModel? = nil
    
    @IBOutlet weak var nameTrip: UILabel!
    @IBOutlet weak var colorTrip: UILabel!
    @IBOutlet weak var dateBeginTrip: UILabel!
    @IBOutlet weak var dateEndTrip: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTrip.text = trip?.name
        self.colorTrip.textColor = trip?.color
        self.dateBeginTrip.text = Date.toString(date: trip!.dateStart)
        self.dateEndTrip.text = Date.toString(date: trip!.dateEnd)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTrip" {
            let editTripViewController = segue.destination as! EditTripViewController
            editTripViewController.trip = self.trip
        }
    }

    
    @IBAction func deleteTripButton(_ sender: Any) {
        // Declare Alert message
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this trip ?", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            self.trip!.delete()
            self.performSegue(withIdentifier: "unwindAfterDeleteTrip", sender: self)
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
