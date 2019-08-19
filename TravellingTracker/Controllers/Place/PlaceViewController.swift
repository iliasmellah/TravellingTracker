//
//  PlaceViewController.swift
//  TravellingTracker
//
//  Created by user154076 on 7/31/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import UIKit

class PlaceViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var trip : TripModel? = nil
    var places : [PlaceModel] = []
    
    @IBOutlet weak var nameTrip: UILabel!
    @IBOutlet weak var colorTrip: UILabel!
    @IBOutlet weak var dateBeginTrip: UILabel!
    @IBOutlet weak var dateEndTrip: UILabel!
    
    @IBOutlet weak var placesCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get info of trip
        self.nameTrip.text = trip?.name
        self.colorTrip.textColor = trip?.color
        self.dateBeginTrip.text = Date.toString(date: trip!.dateStart)
        self.dateEndTrip.text = Date.toString(date: trip!.dateEnd)
        
        //get all places of given trip
        places = Trip.getAllPlaces(trip: trip)!
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTrip" {
            let editTripViewController = segue.destination as! EditTripViewController
            editTripViewController.trip = self.trip
        } else if segue.identifier == "addPlace" {
            let createPlaceViewController = segue.destination as! CreatePlaceViewController
                createPlaceViewController.trip = self.trip
        }
    }
    
    @IBAction func deleteTripButton(_ sender: Any) {
        // Declare Alert message
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this trip ?", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.trip!.delete()
            self.performSegue(withIdentifier: "unwindAfterDeleteTrip", sender: self)
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    var indexPathForShow : IndexPath? = nil
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.places.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Fetch a cell of the appropriate type.
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "placeCell", for: indexPath) as! PlaceCollectionViewCell
        let place = self.places[indexPath.row]
        
        cell.place = place
        
        cell.placeName.text = place.name
        
        return cell
    }
    
    func reloadPlaceCollectionView() {
        self.places = Trip.getAllPlaces(trip: trip)!
        self.placesCollection.reloadData()
    }
    
    //Gets data from CreatePlaceViewController inputs when hits Save
    @IBAction func unwindToPlacesAfterSavingNewPlace(segue: UIStoryboardSegue) {
        reloadPlaceCollectionView()
    }

}
