//
//  ViewController.swift
//  TravellingTracker
//
//  Created by user154076 on 7/8/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    //var tripNames : [String] = ["Bali", "Maroc", "Espagne"]
    var trips : [Trip] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            self.alertError(errorMsg: "Could not save the trip", userInfo: "unknown reason")
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        //creates a request for "Trip" entity
        let request : NSFetchRequest<Trip> = Trip.fetchRequest()
        do {
            try self.trips = context.fetch(request)
        }
        catch let error as NSError{
            self.alertError(errorMsg: "\(error)", userInfo: "\(error.userInfo)")
        }
        
    }
    
    @IBOutlet weak var tripsTable: UITableView!
    
    //Création d'un nouveau trip dans la table view cell
    @IBAction func createAction(_ sender: Any) {
        let alert = UIAlertController(title: "New Trip", message: "Create a new trip", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Create", style: .default)
        {
            [unowned self] action in guard let textField = alert.textFields?.first, let tripToSave = textField.text else {
                return
            }
            self.saveNewTrip(withName: tripToSave)
            self.tripsTable.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    

    func saveNewTrip(withName name: String) {
        //first get context into application delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            self.alertError(errorMsg: "Could not save the trip", userInfo: "unknown reason")
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        //creates a Trips managedObject
        let trip = Trip(context: context)
        
        //then modify the name
        trip.name = name
        do {
            try context.save()
            self.trips.append(trip)
        } catch let error as NSError {
            self.alertError(errorMsg: "\(error)", userInfo: "\(error.userInfo)")
            return
        }
    }
    
    func alertError(errorMsg error : String, userInfo user: String = ""){
        let alert = UIAlertController(title: error, message: user, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(cancelAction)
        present(alert, animated: true)    }
 
    
    // Return the number of rows for the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trips.count
    }
    
    // Provide a cell object for each row.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath) as! TripTableViewCell
        cell.nameTripLabel.text = self.trips[indexPath.row].name
        return cell
    }
    
    //suppression d'un trip
    /*
     func delete(tripWithIndex index: Int) -> Bool {
     guard let context = self.getContext(errorMsg: "Could not delete Trip")
     else {return false}
     let trip = self.tripNames[index]
     context.delete(trip)
     do{
     try context.save()
     self.tripNames.remove(at: index)
     return true
     }
     catch let error as NSError {
     self.alert(error: error)
     return false
     }
     }
     
     func getContext(errorMsg: String, userInfoMsg: String = "could not retrieve data context") -> NSManagedObjectContext?{
     guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
     self.alert(WithTitle: errorMsg, andMessage: userInfoMsg)
     return nil
     }
     return appDelegate.persistentContainer.viewContext
     }
     
     
     //tell if a particular row can be edited
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //manage editing of a row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //just manage deleting
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            self.tripsTable.beginUpdates()
            if self.delete(tripWithIndex: indexPath.row){
                self.tripsTable.deleteRows(at: [indexPath], with: <#T##UITableView.RowAnimation#>)
            }
            self.tripsTable.endUpdates()
        }
    }
*/
}

