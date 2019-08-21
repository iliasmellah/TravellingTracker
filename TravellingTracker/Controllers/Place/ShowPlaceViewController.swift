//
//  ShowPlaceViewController.swift
//  TravellingTracker
//
//  Created by user154076 on 8/20/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import UIKit

class ShowPlaceViewController: UIViewController {

    
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeAddress: UILabel!
    @IBOutlet weak var placeDate: UILabel!
    @IBOutlet weak var placeLatitude: UILabel!
    @IBOutlet weak var placeLongitude: UILabel!
    @IBOutlet weak var placePicture: UIImageView!
    
    var trip : TripModel? = nil
    var place : PlaceModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.placeName.text = place?.name
        self.placeAddress.text = place?.address
        self.placeDate.text = Date.toString(date: place!.date)
        self.placeLatitude.text = place?.latitude
        self.placeLongitude.text = place?.longitude
        self.placePicture.image = place?.picture.rotate(radians: .pi/2)
    }
    
    
    @IBAction func deletePlaceButton(_ sender: Any) {        // Declare Alert message
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this place ?", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.place!.delete()
            self.performSegue(withIdentifier: "unwindAfterDeletePlace", sender: self)
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
