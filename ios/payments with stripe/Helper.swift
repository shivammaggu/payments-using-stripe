//
//  Helper.swift
//  payments with stripe
//
//  Created by Shivam Maggu on 01/02/23.
//

import Foundation
import UIKit

class Helper {
    
    // Common function for creating an UIAlertController with a default action.
    
    static func displayAlert(title: String, message: String? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: "OK",
                                   style: .default)
        
        alertController.addAction(action)
        
        return alertController
    }
}
