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
    @IBOutlet weak var tripColor: UITextField!
    @IBOutlet weak var tripStartDate: UITextField!
    @IBOutlet weak var tripEndDate: UITextField!
    
    var trip : TripModel? = nil
    
    private var startDatePicker: UIDatePicker?
    private var endDatePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //If a trip is received : edition mode. If not, creation mode
        if let trip = self.trip {
            self.tripName.text = trip.name
            self.tripStartDate.text = Date.toString(date: trip.dateStart)
            self.tripEndDate.text = Date.toString(date: trip.dateEnd)
            self.tripColor.text = trip.color.toHexString()
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
        
        tripStartDate.inputAccessoryView = createToolBar()
        tripEndDate.inputAccessoryView = createToolBar()
    }
    
    //Add top tool bar to the date picker
    func createToolBar() -> UIToolbar {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed(sender:)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBar.setItems([flexibleSpace,doneButton, flexibleSpace], animated: true)
        return toolBar
    }
    
    @objc func doneButtonPressed(sender: UIBarButtonItem) {
        tripStartDate.resignFirstResponder()
        tripEndDate.resignFirstResponder()
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)

    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        //Cast date to string
        tripStartDate.text = Date.toString(date: startDatePicker!.date)
        tripEndDate.text = Date.toString(date: endDatePicker!.date)
        
        //Checks if End Date is after Begin Date
        if Date.toDate(dateString: tripStartDate.text!) >  Date.toDate(dateString: tripEndDate.text!) {
            let correctedEndDate = Date.toDate(dateString: tripStartDate.text!).addingTimeInterval(24 * 60 * 60)
            endDatePicker!.date = correctedEndDate
            tripEndDate.text = Date.toString(date: correctedEndDate)
        }
    }
    
    // MARK : - TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
