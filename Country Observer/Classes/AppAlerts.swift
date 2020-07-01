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
    
    
    func noCountryData(for item: CountryError) -> UIAlertController {
        let alert = UIAlertController(title: "Warning", message: "\(item)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        
        return alert
    }
    
    func noHolidayData(for item: HolidayError) -> UIAlertController {
        let alert = UIAlertController(title: "Warning", message: "\(item)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        
        return alert
    }
}
