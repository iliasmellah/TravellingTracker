//
//  ViewController.swift
//  TravellingTracker
//
//  Created by user154076 on 7/8/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import UIKit
import CoreData

class TripViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    /// TableView controlled by self that displays collection of Trips
    @IBOutlet weak var tripsTable: UITableView!
    
    @IBAction func seePlaces(_ sender: Any) {

    }
    
    @IBOutlet var tripPresenter: TripPresenter!
    
    //Collection of Trips to be displayed in self.tripsTable
    var trips : [TripModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        trips = Trip.getAll()!
        
    }
    
    // MARK: - Action Handlers -
    
    //suppression d'un voyage
    func deleteHandlerAction(action: UITableViewRowAction, indexPath: IndexPath) -> Void {
        let trip = self.trips[indexPath.row]
        trip.delete()
        self.reloadTripTableView()
    }
    
    func reloadTripTableView() {
        self.trips = Trip.getAll()!
        self.tripsTable.reloadData()
    }
    
    //edition d'un voyage
    func editHandlerAction(action: UITableViewRowAction, indexPath: IndexPath) -> Void {
        self.indexPathForShow = indexPath
        self.performSegue(withIdentifier: self.segueEditTripId, sender: self)
        self.tripsTable.setEditing(false, animated: true)
    }
    
    
 
    // MARK: - TableView data source protocol -
    
    // Return the number of rows for the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.trips.count
    }
    
    // Provide a cell object for each row.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath) as! TripTableViewCell
        let trip = self.trips[indexPath.row]
        
        cell.nameTripLabel.text = trip.name
        
        //TO DO : collection view
        cell.accessoryType = .detailButton
        
        return cell
    }
    
    //tell if a particular row can be edited
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Création des boutons pour le swipe de la liste des trips
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Delete", handler: self.deleteHandlerAction)
        let edit = UITableViewRowAction(style: .default, title: "Edit", handler: self.editHandlerAction)
        
        delete.backgroundColor = UIColor.red
        edit.backgroundColor = UIColor.blue
        
        return [delete,edit]
    }
    
    
    // MARK: - TableView Delegate Protocol -
    
    var indexPathForShow : IndexPath? = nil
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        //déclenche la liaison entre 2 boards (segue) manuellement
        self.indexPathForShow = indexPath
        self.performSegue(withIdentifier: self.segueShowTripId, sender: self)
    }
    
    
    // MARK: - NSFetchResultController Delegate Protocol -
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //on previent que la table va subir des mises a jour
        self.tripsTable.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //fin de mise à jour
        self.tripsTable.endUpdates()
        
        //sauve les changements après modifs
        CoreDataManager.save()
    }
        
    //quelque chose a change a l'index donné
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                self.tripsTable.deleteRows(at: [indexPath], with: .automatic)
            }
        case .insert:
            if let newIndexPath = newIndexPath {
                self.tripsTable.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                self.tripsTable.reloadRows(at: [indexPath], with: .automatic)
            }
        default:
            break
        }
    }
    
    //indique un changement de section
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            self.tripsTable.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            self.tripsTable.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            break
        }
    }
    
    
    // MARK: - Navigation -
    
    let segueShowTripId = "showTripSegue"
    let segueEditTripId = "editTripSegue"
    let segueShowPlacesId = "placesTripSegue"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //gets the new view controller using segue.destinationViewController
        //passes the selected object to the new view controller
        
        //check if we have the appropriate segue
        if segue.identifier == segueShowTripId {
            // selection d'une cell dans un TableView : 2 possibilités
            // if let indexPath = self.tripsTable.indexPathForSelectedRow
            if let indexPath = self.indexPathForShow {
                let showTripViewController = segue.destination as! ShowTripViewController
                showTripViewController.trip = self.trips[indexPath.row]
                self.tripsTable.deselectRow(at: indexPath, animated: true)
            }
        }
        
        if segue.identifier == segueEditTripId {
            if let indexPath = self.indexPathForShow {
                let editTripViewController = segue.destination as! EditTripViewController
                editTripViewController.trip = self.trips[indexPath.row]
            }
        }
        
        if segue.identifier == segueShowPlacesId {
            if let indexPath = self.indexPathForShow {
                let placeViewController = segue.destination as! PlaceViewController
                placeViewController.trip = self.trips[indexPath.row]
                self.tripsTable.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    //Gets data from CreateTripViewController inputs when hits Save
    @IBAction func unwindToTripsAfterSavingNewTrip(segue: UIStoryboardSegue) {
        self.trips = Trip.getAll()!
        self.tripsTable.reloadData()
        
    }
    
    @IBAction func unwindToTripsAfterEditingTrip(segue: UIStoryboardSegue) {
        if let controller = segue.source as? EditTripViewController {
            if let trip = controller.trip {
                trip.save()
            }
        }
        self.tripsTable.reloadData()
    }
    
    
    // MARK: - helper methods -
    /// get context of core data initialized in application delegate
    ///
    /// - Parameters:
    ///   - errorMsg: main error message
    ///   - userInfoMsg: additional information user wants to display
    /// - Returns: context of CoreData
    func getContext(errorMsg: String, userInfoMsg: String = "could not retrieve data context") -> NSManagedObjectContext?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            self.alert(WithTitle: errorMsg, andMessage: userInfoMsg)
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    /// Show an alert dialog box with 2 messages
    ///
    /// - Parameters:
    ///   - title: title of dialog box seen as main message
    ///   - msg: additional message used to describe context of additional information
    func alert(WithTitle title : String, andMessage msg : String = "") {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    /// Show an alert to inform about an error
    ///
    /// - Parameter error: error we want information about
    func alert(error: NSError) {
        self.alert(WithTitle: "\(error)", andMessage: "\(error.userInfo)")
    }

}
