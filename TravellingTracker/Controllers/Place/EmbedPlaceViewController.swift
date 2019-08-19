//
//  EmbedPlaceViewController.swift
//  TravellingTracker
//
//  Created by user154076 on 8/19/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import UIKit

class EmbedPlaceViewController: UIViewController {

    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeDate: UITextField!
    
    var trip : TripModel?
    var place: PlaceModel?
    
    @IBOutlet weak var tripName: UILabel!
    
    private var datePicker:UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tripName.text = trip?.name
        
        if let place = self.place {
            self.placeName.text = place.name
            self.placeDate.text = Date.toString(date: place.date)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EmbedPlaceViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(EmbedPlaceViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        placeDate.inputView = datePicker
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        //Gets data with Date format
        placeDate.text = Date.toString(date: datePicker.date)
        view.endEditing(true)
    }
    
    // MARK : - TextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


}
