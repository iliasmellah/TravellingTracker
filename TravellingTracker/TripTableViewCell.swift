//
//  TripTableViewCell.swift
//  TravellingTracker

//  Created by user154076 on 7/8/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import UIKit

class TripTableViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tripName: UILabel!
    @IBOutlet weak var tripColor: UILabel!
    @IBOutlet weak var tripBeginDate: UILabel!
    @IBOutlet weak var tripEndDate: UILabel!
    
    var trip : TripModel? = nil
}
