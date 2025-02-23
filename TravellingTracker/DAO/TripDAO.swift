//
//  TripDAO.swift
//  TravellingTracker
//
//  Created by user154076 on 8/10/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension Trip {
    
    // gets all trips
    static func getAll() -> [TripModel]? {
        let context = CoreDataManager.context
        let request : NSFetchRequest<Trip> = Trip.fetchRequest()
        var tripsFetched : [Trip]?
        var tripModels : [TripModel] = []
        do {
            try tripsFetched = context.fetch(request)
            if let trips = tripsFetched {
                for trip in trips {
                    let sanitizedTrip = TripModel(trip: trip)
                    tripModels.append(sanitizedTrip)
                }
            }
        } catch {
            fatalError()
        }
        return tripModels
    }
    
    // gets all places for a given trip
    static func getAllPlaces(trip: TripModel?) -> [PlaceModel]? {
        let places = trip!.tripCD.places?.allObjects as? [Place]
        var placesModels: [PlaceModel] = []
        if let place = places {
            for plc in place {
                placesModels.append(PlaceModel(place: plc))
            }
        }
        return placesModels
    }
    
    //d eletes a given trip
    static func delete(trip: Trip) {
        do {
            try CoreDataManager.delete(object: trip)
            self.save()
        } catch {
            fatalError("Unable to delete")
        }
    }
    
    // creates a trip
    static func create() -> Trip {
        return Trip(context: CoreDataManager.context)
    }
    
    // saves a trip
    static func save() {
        CoreDataManager.save()
    }
}
