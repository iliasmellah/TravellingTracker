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
    var places : [PlaceModel]? = []
    
    @IBOutlet weak var nameTrip: UILabel!
    @IBOutlet weak var colorTrip: UILabel!
    @IBOutlet weak var dateBeginTrip: UILabel!
    @IBOutlet weak var dateEndTrip: UILabel!
    
    @IBOutlet weak var placesCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get info of trip from Trip View COntroller and displays it
        self.nameTrip.text = trip?.name
        self.colorTrip.textColor = trip?.color
        self.dateBeginTrip.text = Date.toString(date: trip!.dateStart)
        self.dateEndTrip.text = Date.toString(date: trip!.dateEnd)
        
        //get all places of the given trip and sort by date : get the new on top
        places = Trip.getAllPlaces(trip: trip)!
        places?.sort(by: { $0.date > $1.date })
    }
    
    @IBAction func deleteTripButton(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this trip ?", preferredStyle: .alert)
        
        // creates OK button with aits ction handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.trip!.delete()
            self.performSegue(withIdentifier: "unwindAfterDeleteTrip", sender: self)
        })
        
        // creates Cancel button with its action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in }
        
        // adds OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // displays dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    // MARK: - Collection View -
    var indexPathForShow : IndexPath? = nil
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.places!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Fetch a cell of the appropriate type.
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "placeCell", for: indexPath) as! PlaceCollectionViewCell
        let place = self.places![indexPath.row]
        
        cell.trip = self.trip
        cell.place = place
        
        if place.name != "" { cell.placeName.text = place.name } else { cell.placeName.text = "No name yet" }
        cell.placePicture.image = place.picture.rotate(radians: .pi/2)
        cell.placeAddress.text = place.address
        
        return cell
    }
    
    func reloadPlaceCollectionView() {
        self.places = Trip.getAllPlaces(trip: trip)!
        self.placesCollection.reloadData()
    }
    
    // MARK: - Unwinds -
    //Gets data from CreatePlaceViewController inputs when hits Save
    @IBAction func unwindToPlacesAfterSavingNewPlace(segue: UIStoryboardSegue) {
        reloadPlaceCollectionView()
    }
    
    @IBAction func unwindToPlacesAfterDeletingPlace(segue: UIStoryboardSegue) {
        reloadPlaceCollectionView()
    }
    
    @IBAction func unwindToPlacesAfterEditingPlace(segue: UIStoryboardSegue) {
        if let controller = segue.source as? EditPlaceViewController {
            if let place = controller.place {
                place.save()
            }
        }
        self.placesCollection.reloadData()
    }
    
    // MARK: - Navigation -
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTrip" {
            let editTripViewController = segue.destination as! EditTripViewController
            editTripViewController.trip = self.trip
        } else if segue.identifier == "addPlace" {
            let createPlaceViewController = segue.destination as! CreatePlaceViewController
            createPlaceViewController.trip = self.trip
        } else if segue.identifier == "fullMapSegue" {
            let fullMapViewController = segue.destination as! FullMapViewController
            fullMapViewController.trip = self.trip
            fullMapViewController.places = self.places
            if !self.places!.isEmpty {
                fullMapViewController.placeCenter = self.places![0]
            }
        } else if let controller = segue.destination as? ShowPlaceViewController {
            if let cell = sender as? PlaceCollectionViewCell {
                controller.trip = cell.trip
                controller.place = cell.place
            }
        }
    }

}
