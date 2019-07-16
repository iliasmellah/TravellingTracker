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
    
    @IBOutlet var tripPresenter: TripPresenter!
    
    //Collection of Trips to be displayed in self.tripsTable
    var trips : [Trip] = []
    
    fileprivate lazy var tripsFetched : NSFetchedResultsController<Trip> = {
        //prepare a request
        let request : NSFetchRequest<Trip> = Trip.fetchRequest()
        //tri des données
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Trip.name), ascending: true)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.context, sectionNameKeyPath: #keyPath(Trip.name), cacheName: nil)
        fetchResultController.delegate = self
        return fetchResultController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //first get context of persistent data
        //guard let context = self.getContext(errorMsg: "Could note load data") else {return}
        
        //creates a request for "Trip" entity
        //let request : NSFetchRequest<Trip> = Trip.fetchRequest()
        do {
            //try self.trips = context.fetch(request)
            try self.tripsFetched.performFetch()
        }
        catch let error as NSError{
            DialogBoxHelper.alert(view: self, error: error)
        }
        
    }
    
    
    /*
    /// Displays adialog box to allow user to enter a trip name. Then creates of a new Trip, add it to table view and saves data
    ///
    /// - Parameter sender: object that trigger action
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
 */
    
    // MARK: - Action Handlers -
    
    //suppression d'un voyage
    func deleteHandlerAction(action: UITableViewRowAction, indexPath: IndexPath) -> Void {
        let trip = self.tripsFetched.object(at: indexPath)
        print("XXXXX : ", indexPath)
        CoreDataManager.context.delete(trip)
        /*self.tripsTable.beginUpdates()
         if self.delete(tripWithIndex: indexPath.row) {
            self.tripsTable.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
        self.tripsTable.endUpdates()*/
    }
    
    //edition d'un voyage
    func editHandlerAction(action: UITableViewRowAction, indexPath: IndexPath) -> Void {
        print("Edit Handler : ", indexPath.row)
        self.indexPathForShow = indexPath
        self.performSegue(withIdentifier: self.segueEditTripId, sender: self)
        self.tripsTable.setEditing(false, animated: true)
    }
    
    
    // MARK: - Trip data managment -
    
    func save() {
        if let error = CoreDataManager.save(){
            DialogBoxHelper.alert(view: self, error: error
            )
        }
    }

    /// create a new Trip, add it to the collection and saves it
    ///
    /// - Parameter name: name of Trip to be added
    func saveNewTrip(withName name: String, andStartDate startDate: Date, andEndDate endDate: Date, andColor color: String) {
        //first get context into application delegate
        guard let context = self.getContext(errorMsg: "Save failed") else { return }
        
        //creates a Trips managedObject
        let trip = Trip(context: context)
        
        //then modify the name
        trip.name = name
        trip.dateStart = startDate
        trip.dateEnd = endDate
        trip.color = color
        do {
            try context.save()
            self.trips.append(trip)
        } catch let error as NSError {
            self.alert(error: error)
            return
        }
    }
    
    //suppression d'un trip
    /// deletes a trip fro mcollection thanks to its index
    /// - Precondition: tripWithIndex must be into bound of colelction
    /// - Parameter index: tripWithIndex description
    /// - Returns: true if collection occurs, else false
    func delete(tripWithIndex index: Int) -> Bool {
        guard let context = self.getContext(errorMsg: "Could not delete Trip") else {return false}
        let trip = self.trips[index]
        context.delete(trip)
        do{
            try context.save()
            self.trips.remove(at: index)
            return true
        }
        catch let error as NSError {
            self.alert(error: error)
            return false
        }
    }
 
    // MARK: - TableView data source protocol -
    
    //renvoie nombre de sections
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = self.tripsFetched.sections else {return 0}
        return sections.count
    }
    
    // Return the number of rows for the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.trips.count
        guard let section = self.tripsFetched.sections?[section] else {
            fatalError("Unexpected section number")
        }
        return section.numberOfObjects
    }
    
    //titre des sections
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = self.tripsFetched.sections?[section] else {
            fatalError("Unexpected section number")
        }
        return section.name
    }
    
    // Provide a cell object for each row.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath) as! TripTableViewCell
        let trip = self.tripsFetched.object(at: indexPath)
        self.tripPresenter.configure(theCell: cell, forTrip: trip)
        //self.tripPresenter.configure(theCell: cell, forTrip: self.trips[indexPath.row])
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
    
    //supprimée pour la fonction deleteHandlerAction à la place
    //manage editing of a row
    /*func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //just manage deleting
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            self.tripsTable.beginUpdates()
            if self.delete(tripWithIndex: indexPath.row){
                self.tripsTable.deleteRows(at: [indexPath], with: .automatic)
            }
            self.tripsTable.endUpdates()
        }
    }*/
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //gets the new view controller useing segue.destinationViewController
        //passes the selected object to the new view controller
        
        //check if we have the appropriate segue
        if segue.identifier == segueShowTripId {
            // selection d'une cell dans un TableView : 2 possibilités
            // if let indexPath = self.tripsTable.indexPathForSelectedRow
            if let indexPath = self.indexPathForShow {
                let showTripViewController = segue.destination as! ShowTripViewController
                showTripViewController.trip = self.tripsFetched.object(at: indexPath)
                self.tripsTable.deselectRow(at: indexPath, animated: true)
            }
        }
        
        if segue.identifier == segueEditTripId {
            if let indexPath = self.indexPathForShow {
                let editTripViewController = segue.destination as! EditTripViewController
                editTripViewController.trip = self.tripsFetched.object(at: indexPath)
            }
        }
    }
    
    //Gets data from CreateTripViewController inputs when hits Save
    @IBAction func unwindToTripsAfterSavingNewTrip(segue: UIStoryboardSegue) {
        
        let createTripController = segue.source as! CreateTripViewController
        let embedTripController = createTripController.children[0] as! EmbedTripViewController
        
        let name = embedTripController.tripName.text ?? ""
        let startDate = embedTripController.tripStartDateReal ?? Date.currentDate()
        let endDate = embedTripController.tripEndDateReal ?? Date.currentDate()
        let color = embedTripController.tripColor.text ?? ""
        
        
        self.saveNewTrip(withName: name, andStartDate: startDate, andEndDate: endDate, andColor: color)
        self.tripsTable.reloadData()
    }
    
    @IBAction func unwindToTripsAfterEditingTrip(segue: UIStoryboardSegue) {
        self.save()
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

