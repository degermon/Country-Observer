//
//  SafeCountryDataUnwrap.swift
//  Country Observer
//
//  Created by Daniel Šuškevič on 2020-06-30.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import Foundation

class SafeCountryDataUnwrap { // Class specificaly to unwrap optional country details to string
    
    func safelyUnwrapString(item: String?) -> String {
        if let item = item {
            return item
        } else {
            return "-"
        }
    }
    
    func safelyUnwrapInt(item: Int?) -> String {
        if let item = item {
            return String(item)
        } else {
            return "-"
        }
    }
    
    func processCurrencies(currencies: [Currency]?) -> String {
        var currencyList = ""
        guard let currencies = currencies else { return "-" }
        
        for item in currencies {
            if currencyList != "" {
                currencyList.append(contentsOf: ", ")
            }
            currencyList.append(contentsOf: "\(safelyUnwrapString(item: item.name)) short for \(safelyUnwrapString(item: item.code)) and has a symbol of \(safelyUnwrapString(item: item.symbol))")
        }
        
        return currencyList
    }
    
    func processLanguages(languages: [Language]?) -> String {
        var languageList = ""
        guard let languages = languages else { return "-" }
        
        for item in languages {
            if languageList != "" {
                languageList.append(contentsOf: ", ")
            }
            languageList.append(contentsOf: "\(safelyUnwrapString(item: item.name))")
        }
        
        return languageList
    }
    
    func processTimezones(timezones: [String?]?) -> String {
        var timezoneList = ""
        guard let timezonesArray = timezones else { return "-" }
        
        for item in timezonesArray {
            if timezoneList != "" {
                timezoneList.append(contentsOf: " and ")
            }
            if let timezone = item {
                timezoneList.append(contentsOf: timezone)
            }
        }
        
        return timezoneList
    }
}
