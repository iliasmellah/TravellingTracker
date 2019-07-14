//
//  CreateTripViewController.swift
//  TravellingTracker
//
//  Created by user154076 on 7/10/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import UIKit

class CreateTripViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var tripName: UITextField!
    @IBOutlet weak var tripStartDate: UITextField!
    @IBOutlet weak var tripEndDate: UITextField!
    @IBOutlet weak var tripColor: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    // MARK : - CREATE & SAVE A TRIP
    @IBAction func cancelTrip(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTrip(_ sender: Any) {
        
    }
    
    // MARK : - TextField Delegate -
    
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
