//
//  TripTableViewCell.swift
//  TravellingTracker

//  Created by user154076 on 7/8/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import UIKit

protocol TripTableViewCellDelegate {
    func didTapSeePlaces(trip: Trip)
}

class TripTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameTripLabel: UILabel!
    
    @IBAction func buttonPlaces(_ sender: Any) {
        
    }

}
