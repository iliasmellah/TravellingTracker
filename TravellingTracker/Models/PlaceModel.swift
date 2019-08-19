//
//  PlaceModel.swift
//  TravellingTracker
//
//  Created by user154076 on 8/18/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class PlaceModel {
    
    internal var placeCD : Place
    
    var name : String {
        get { return self.placeCD.name! }
        set { self.placeCD.name = newValue}
    }
    
    var address : String {
        get { return self.placeCD.address! }
        set { self.placeCD.address = newValue}
    }
    
    var date : Date {
        get { return self.placeCD.date! as Date }
        set { self.placeCD.date = newValue as Date}
    }
    
    var latitude : String {
        get { return self.placeCD.latitude! }
        set { self.placeCD.latitude = newValue}
    }
    
    var longitude : String {
        get { return self.placeCD.longitude! }
        set { self.placeCD.longitude = newValue}
    }
    
    var picture : UIImage {
        get { return UIImage(data: self.placeCD.picture!)! }
        set { self.placeCD.picture = newValue.pngData()}
    }
    
    // a place belongs to one trip
    var trip : Trip {
        get{ return self.placeCD.trip! }
        set { self.placeCD.trip = newValue }
    }
    
    func delete() {
        Place.delete(place: self.placeCD)
    }
    
    func save() {
        Place.save()
    }
    
    init(name: String, date: Date, trip: TripModel) {
        self.placeCD = Place.create()
        self.placeCD.name = name
        self.placeCD.date = date as Date
        self.placeCD.trip = trip.tripCD
    }
    
    init(name: String, address: String, date: Date, latitude: String, longitude: String, picture: UIImage, trip: TripModel) {
        self.placeCD = Place.create()
        self.placeCD.name = name
        self.placeCD.address = address
        self.placeCD.date = date as Date
        self.placeCD.latitude = latitude
        self.placeCD.longitude = longitude
        self.placeCD.picture = picture.pngData()
        
        self.placeCD.trip = trip.tripCD
    }
    
    init(place: Place) {
        self.placeCD = place
    }
}
