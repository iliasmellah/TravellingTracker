//
//  DialogBoxHelper.swift
//  TravellingTracker
//
//  Created by user154076 on 7/15/19.
//  Copyright © 2019 user154076. All rights reserved.
//

import Foundation
import UIKit

class DialogBoxHelper {
    
    class func alert(view: UIViewController, WithTitle title : String, andMessage msg : String = "") {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(cancelAction)
        view.present(alert,animated: true)
    }
    
    class func alert(view: UIViewController, error: NSError) {
        self.alert(view: view, WithTitle: "\(error)", andMessage: "\(error.userInfo)")
    }
}
