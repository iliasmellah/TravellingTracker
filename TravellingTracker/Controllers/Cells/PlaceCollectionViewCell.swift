//
//  PlaceCollectionViewCell.swift
//  TravellingTracker
//
//  Created by user154076 on 8/18/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import UIKit

class PlaceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placePicture: UIImageView!
    
    var trip : TripModel? = nil
    var place : PlaceModel? = nil
}
