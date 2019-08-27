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
    
    //Collection of Trips to be displayed in self.tripsTable
    var trips : [TripModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get all trips
        trips = Trip.getAll()!
        
        //sort by date of start trip : get the new on top
        trips.sort(by: { $0.dateStart > $1.dateStart })
    }

    // reloads the trips collection
    func reloadTripTableView() {
        self.trips = Trip.getAll()!
        self.tripsCollection.reloadData()
    }
    
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
    
    // MARK: - Unwinds -
    @IBAction func unwindToTripsAfterSavingNewTrip(segue: UIStoryboardSegue) {
        reloadTripTableView()
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
        reloadTripTableView()
    }

}
