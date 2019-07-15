//
//  CoreDataManager.swift
//  TravellingTracker
//
//  Created by user154076 on 7/15/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager: NSObject {
    //already lazy
    static var context : NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            exit(EXIT_FAILURE)
        }
        return appDelegate.persistentContainer.viewContext
    }()
    
    @discardableResult    //permet a une fonction d'etre utilisée comme une procédure
    class func save() -> NSError? {
        //try to save
        do {
            try CoreDataManager.context.save()
            return nil
        } catch let error as NSError {
            return error
        }
    }
}
