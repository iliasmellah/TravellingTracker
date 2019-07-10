//
//  CreateTripViewController.swift
//  TravellingTracker
//
//  Created by user154076 on 7/10/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import UIKit

class CreateTripViewController: UIViewController {
    
    
    @IBOutlet weak var tripName: UITextField!
    @IBOutlet weak var tripStartDate: UITextField!
    @IBOutlet weak var tripEndDate: UITextField!
    
    
    private var startDatePicker: UIDatePicker?
    private var endDatePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startDatePicker = UIDatePicker()
        endDatePicker = UIDatePicker()
        
        startDatePicker?.datePickerMode = .date
        startDatePicker?.addTarget(self, action: #selector(CreateTripViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        endDatePicker?.datePickerMode = .date
        endDatePicker?.addTarget(self, action: #selector(CreateTripViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateTripViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        tripStartDate.inputView = startDatePicker
        tripEndDate.inputView = endDatePicker
        
        // Do any additional setup after loading the view.
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        tripStartDate.text = Date.toString(date: startDatePicker!.date)
        tripEndDate.text = Date.toString(date: endDatePicker!.date)
        view.endEditing(true)
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
