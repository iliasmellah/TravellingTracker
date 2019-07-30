//
//  PlaceViewController.swift
//  TravellingTracker
//
//  Created by user154076 on 7/9/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import UIKit

class ShowTripViewController: UIViewController {

    @IBOutlet weak var nameTrip: UILabel!
    @IBOutlet weak var dateStartTrip: UILabel!
    @IBOutlet weak var dateEndTrip: UILabel!
    @IBOutlet weak var colorTrip: UILabel!
    
    @IBOutlet weak var colorCodeTrip: UILabel!
    
    var trip : Trip? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //if a trip has been sent, display it
        if let atrip = self.trip {
            if atrip.name == "" {
                self.nameTrip.text = " - "
            } else {
                self.nameTrip.text = atrip.name?.capitalized
            }
            self.dateStartTrip.text = Date.toString(date: atrip.dateStart ?? Date.currentDate())
            self.dateEndTrip.text = Date.toString(date: atrip.dateEnd ?? Date.currentDate())
            
            if atrip.color == "" {
                self.colorTrip.text = " Grey "
            } else {
                self.colorTrip.text = atrip.color?.capitalized
            }
            
            self.colorCodeTrip.textColor = self.colorFromHex(hex : atrip.color!)
        }
    }
    
    //Get color from hex code
    func colorFromHex(hex : String) -> UIColor {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        
        if hexString.count != 6 {
            return UIColor.black
        }
        
        var rgb : UInt32 = 0
        Scanner(string: hexString).scanHexInt32(&rgb)
        
        return UIColor.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                            blue: CGFloat((rgb & 0x0000FF)) / 255.0,
                            alpha: 1.0)
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
