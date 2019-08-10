//
//  PlaceViewController.swift
//  TravellingTracker
//
//  Created by user154076 on 7/31/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import UIKit

class PlaceViewController: UIViewController {

    @IBOutlet weak var nameTripLabel: UILabel!
    
    var trip : TripModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let atrip = self.trip {
            if atrip.name == "" {
                self.nameTripLabel.text = " - "
            } else {
                self.nameTripLabel.text = atrip.name.capitalized
            }
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
