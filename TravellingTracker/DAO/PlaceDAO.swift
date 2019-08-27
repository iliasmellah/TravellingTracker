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
    
    // deletes a given place
    static func delete(place: Place) {
        do {
            try CoreDataManager.delete(object: place)
            self.save()
        } catch {
            fatalError("Unable to delete")
        }
    }
    
    // creates a place
    static func create() -> Place {
        return Place(context: CoreDataManager.context)
    }
    
    // saves a place
    static func save() {
        CoreDataManager.save()
    }
    
}
