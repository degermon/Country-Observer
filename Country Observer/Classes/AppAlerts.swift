//
//  AppAlerts.swift
//  Country Observer
//
//  Created by Daniel Šuškevič on 2020-06-30.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import UIKit

class AppAlerts {
    
    func noInternetConnection() -> UIAlertController {
        let alert = UIAlertController(title: "Warning", message: "There is no internet connection", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        
        return alert
    }
}
