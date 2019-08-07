//
//  EmbedTripViewController.swift
//  TravellingTracker
//
//  Created by user154076 on 7/11/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import UIKit

class EmbedTripViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var tripName: UITextField!
    @IBOutlet weak var tripStartDate: UITextField!
    @IBOutlet weak var tripEndDate: UITextField!
    @IBOutlet weak var tripColor: UITextField!
    
    var tripStartDateReal: Date!
    var tripEndDateReal: Date!
    
    var trip : Trip? = nil
    
    private var startDatePicker: UIDatePicker?
    private var endDatePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Si on a un voyage, mode edition. Sinon mode ajout
        if let trip = self.trip {
            self.tripName.text = trip.name
            self.tripStartDate.text = Date.toString(date: trip.dateStart!)
            self.tripEndDate.text = Date.toString(date: trip.dateEnd!)
            self.tripColor.text = trip.color
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EmbedTripViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)

        //Date Picker in UITextField
        startDatePicker = UIDatePicker()
        startDatePicker?.datePickerMode = .date
        startDatePicker?.addTarget(self, action: #selector(EmbedTripViewController.dateChanged(datePicker:)), for: .valueChanged)

        endDatePicker = UIDatePicker()
        endDatePicker?.datePickerMode = .date
        endDatePicker?.addTarget(self, action: #selector(EmbedTripViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        tripStartDate.inputView = startDatePicker
        tripEndDate.inputView = endDatePicker
        //End of Date Picker
    }
    
    // MARK : - DATE PICKER -
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        //Gets data with Date format
        tripStartDateReal = Date.toDate(dateString: tripStartDate.text!)
        tripEndDateReal = Date.toDate(dateString: tripEndDate.text!)
        
        tripStartDate.text = Date.toString(date: startDatePicker!.date)
        tripEndDate.text = Date.toString(date: endDatePicker!.date)
        
        view.endEditing(true)
    }
    
    // MARK : - TextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
