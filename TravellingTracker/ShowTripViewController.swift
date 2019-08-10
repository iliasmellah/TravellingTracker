//
//  PlaceViewController.swift
//  TravellingTracker
//
//  Created by user154076 on 7/9/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import UIKit

class ShowTripViewController: UIViewController {

    @IBOutlet weak var nameTrip: UILabel!
    @IBOutlet weak var dateStartTrip: UILabel!
    @IBOutlet weak var dateEndTrip: UILabel!    
    @IBOutlet weak var colorCodeTrip: UILabel!
    
    var trip : TripModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //if a trip has been sent, display it
        if let atrip = self.trip {
            if atrip.name == "" {
                self.nameTrip.text = " - "
            } else {
                self.nameTrip.text = atrip.name.capitalized
            }
            self.dateStartTrip.text = Date.toString(date: atrip.dateStart)
            self.dateEndTrip.text = Date.toString(date: atrip.dateEnd)
            self.colorCodeTrip.textColor = atrip.color
        }
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
