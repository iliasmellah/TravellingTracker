//
//  TripTableViewCell.swift
//  TravellingTracker

//  Created by user154076 on 7/8/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import UIKit

class TripTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameTripLabel: UILabel!
    @IBAction func buttonPlaces(_ sender: Any) {
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
