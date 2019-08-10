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
        print("\nArrivé dans le placeViewController\n")
        self.nameTrip.text = trip?.name
        self.colorTrip.textColor = trip?.color
        self.dateBeginTrip.text = Date.toString(date: trip!.dateStart)
        self.dateEndTrip.text = Date.toString(date: trip!.dateEnd)
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
