//
//  PlaceDAO.swift
//  TravellingTracker
//
//  Created by user154076 on 8/18/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension Place {
    
    /*static func getAll() -> [PlaceModel]? {
        let context = CoreDataManager.context
        let request : NSFetchRequest<Place> = Place.fetchRequest()
        var placesFetched : [Place]?
        var placeModels : [PlaceModel] = []
        do {
            try placesFetched = context.fetch(request)
            
            if let places = placesFetched {
                for place in places {
                    let sanitizedPlace = PlaceModel(place: place)
                    placeModels.append(sanitizedPlace)
                }
            }
            
        } catch {
            fatalError()
        }
        
        return placeModels
    }*/
    
    static func delete(place: Place) {
        do {
            try CoreDataManager.delete(object: place)
            self.save()
        } catch {
            fatalError("Unable to delete")
        }
    }
    
    static func create() -> Place {
        return Place(context: CoreDataManager.context)
    }
    
    static func save() {
        CoreDataManager.save()
    }
    
}
