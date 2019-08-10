//
//  TripModel.swift
//  TravellingTracker
//
//  Created by user154076 on 8/10/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import Foundation
import UIKit

class TripModel {
    
    internal var tripCD : Trip
    
    var name : String {
        get { return self.tripCD.name! }
        set { self.tripCD.name = newValue }
    }
    
    var color : UIColor {
        get { return self.tripCD.color!.colorFromHex() }
        set { self.tripCD.color = newValue.toHexString() }
    }
    
    var dateStart : Date {
        get { return self.tripCD.dateStart! }
        set { self.tripCD.dateStart = newValue }
    }

    var dateEnd : Date {
        get { return self.tripCD.dateEnd! }
        set { self.tripCD.dateEnd = newValue }
    }
    
    func delete() {
        Trip.delete(trip: self.tripCD)
    }
    
    func save() {
        Trip.save()
    }
    
    init(name: String, dateStart: Date, dateEnd : Date, color : UIColor) {
        self.tripCD = Trip.create()
        self.name = name
        self.dateStart = dateStart
        self.dateEnd = dateEnd
        self.color = color
    }
    
    init(trip: Trip) {
        self.tripCD = trip
    }
    
}
