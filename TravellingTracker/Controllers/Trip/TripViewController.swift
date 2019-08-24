//
//  ViewController.swift
//  TravellingTracker
//
//  Created by user154076 on 7/8/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import UIKit
import CoreData

class TripViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate,  NSFetchedResultsControllerDelegate {
    
    /// TableView controlled by self that displays collection of Trips
    
    @IBOutlet weak var tripsCollection: UICollectionView!
    
    @IBOutlet var tripPresenter: TripPresenter!
    
    //Collection of Trips to be displayed in self.tripsTable
    var trips : [TripModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get all trips
        trips = Trip.getAll()!
        
        //sort by date of start trip : get the new on top
        trips.sort(by: { $0.dateStart > $1.dateStart })
        
    }

    func reloadTripTableView() {
        self.trips = Trip.getAll()!
        self.tripsCollection.reloadData()
    }
 
    // MARK: - TableView data source protocol -
    
    // Return the number of rows for the collection.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return self.trips.count
    }
    
    // Provide a cell object for each row.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Fetch a cell of the appropriate type.
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tripCell", for: indexPath) as! TripCollectionViewCell
        let trip = self.trips[indexPath.row]
        
        cell.trip = trip
        
        cell.tripName.text = trip.name
        cell.tripColor.textColor = trip.color
        cell.tripBeginDate.text = Date.toString(date: trip.dateStart)
        cell.tripEndDate.text = Date.toString(date: trip.dateEnd)
        return cell
    }
    
//    //tell if a particular row can be edited
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    // Création des boutons pour le swipe de la liste des trips
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let delete = UITableViewRowAction(style: .default, title: "Delete", handler: self.deleteHandlerAction)
//        let edit = UITableViewRowAction(style: .default, title: "Edit", handler: self.editHandlerAction)
//
//        delete.backgroundColor = UIColor.red
//        edit.backgroundColor = UIColor.blue
//
//        return [delete,edit]
//    }
//
    
    // MARK: - TableView Delegate Protocol -
    
    var indexPathForShow : IndexPath? = nil
    
//    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
//        //déclenche la liaison entre 2 boards (segue) manuellement
//        self.indexPathForShow = indexPath
//        self.performSegue(withIdentifier: self.segueShowTripId, sender: self)
//    }
    
    
    // MARK: - NSFetchResultController Delegate Protocol -
//    
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        //on previent que la table va subir des mises a jour
//        self.tripsCollection.beginUpdates()
//    }
//    
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        //fin de mise à jour
//        self.tripsCollection.endUpdates()
//        
//        //sauve les changements après modifs
//        CoreDataManager.save()
//    }
        
//    //quelque chose a change a l'index donné
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        switch type {
//        case .delete:
//            if let indexPath = indexPath {
//                self.tripsCollection.deleteRows(at: [indexPath], with: .automatic)
//            }
//        case .insert:
//            if let newIndexPath = newIndexPath {
//                self.tripsCollection.insertRows(at: [newIndexPath], with: .automatic)
//            }
//        case .update:
//            if let indexPath = indexPath {
//                self.tripsCollection.reloadRows(at: [indexPath], with: .automatic)
//            }
//        default:
//            break
//        }
//    }
//
//    //indique un changement de section
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//        switch type {
//        case .insert:
//            self.tripsTable.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
//        case .delete:
//            self.tripsTable.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
//        default:
//            break
//        }
//    }
//
    
    // MARK: - Navigation -
    
    let segueShowTripId = "showTripSegue"
    let segueEditTripId = "editTripSegue"
    let segueShowPlacesId = "placesTripSegue"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //gets the new view controller using segue.destinationViewController
        //passes the selected object to the new view controller
        if let controller = segue.destination as? PlaceViewController {
            if let cell = sender as? TripCollectionViewCell {
                controller.trip = cell.trip
            }
        }
    }
    
    //Gets data from CreateTripViewController inputs when hits Save
    @IBAction func unwindToTripsAfterSavingNewTrip(segue: UIStoryboardSegue) {
        self.trips = Trip.getAll()!
        self.tripsCollection.reloadData()
        
    }
    
    @IBAction func unwindToTripsAfterEditingTrip(segue: UIStoryboardSegue) {
        if let controller = segue.source as? EditTripViewController {
            if let trip = controller.trip {
                trip.save()
            }
        }
        self.tripsCollection.reloadData()
    }
    
    @IBAction func unwindToTripsAfterDeletingTrip(segue: UIStoryboardSegue) {
        self.trips = Trip.getAll()!
        self.tripsCollection.reloadData()
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
