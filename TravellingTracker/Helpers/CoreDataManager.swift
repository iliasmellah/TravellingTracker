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
    
    static var context : NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            exit(EXIT_FAILURE)
        }
        return appDelegate.persistentContainer.viewContext
    }()
    
    //permet a une fonction d'etre utilisée comme une procédure
    @discardableResult
    class func save() -> NSError? {
        //tries to save
        do {
            try CoreDataManager.context.save()
            return nil
        } catch let error as NSError {
            return error
        }
    }
    
    class func delete(object: NSManagedObject) throws {
        CoreDataManager.context.delete(object)
    }
}
