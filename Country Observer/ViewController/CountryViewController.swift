//
//  CountryViewController.swift
//  Country Observer
//
//  Created by Daniel Šuškevič on 2020-06-28.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import UIKit

class CountryViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var showHolidaysButton: UIButton!
    
    var country: Country?
    private var holidays: [HolidayDetail] = []
    
    // MARK: - Config
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle()
        getHolidays {
            self.composeText()
        }
    }
        
    func setTitle() { // set navigation title
        guard let countryName = country?.name else {
            return
        }
        self.title = countryName
    }
    
    func getHolidays(completion: @escaping ()->()) {
        if let countryShortName = country?.alpha2Code {
            let holiday = HolidayRequest(countryCode: countryShortName)
            holiday.getHolidays { [weak self] result in
                switch result{
                case .failure(let error):
                    print(error)
                    completion()
                case .success(let holidaysList):
                    self?.holidays = holidaysList
                    DispatchQueue.main.async {
                        self?.showHolidaysButton.isHidden = false
                    }
                    completion()
                }
            }
        }
    }
    
    // MARK: - Text
    
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
    
    func composeText() {
        var textToDisplay = ""
        textToDisplay.append(contentsOf: "\(safelyUnwrapString(item: country?.name)) is a country located in \(safelyUnwrapString(item: country?.region)) and it's capital is \(safelyUnwrapString(item: country?.capital)).")
        textToDisplay.append(contentsOf:  "The short form of this country name is \(safelyUnwrapString(item: country?.alpha2Code)).\n")
        textToDisplay.append(contentsOf: "This country has a population of \(safelyUnwrapInt(item: country?.population)) people.\n")
        textToDisplay.append(contentsOf: "The currency used in this country is \(processCurrencies(currencies: country?.currencies)).\n")
        textToDisplay.append(contentsOf: "The language used in \(safelyUnwrapString(item: country?.name)) is \(processLanguages(languages: country?.languages)).\n")
        textToDisplay.append(contentsOf: "This country falls timezone is \(processTimezones(timezones: country?.timezones)).\n")
        if holidays.isEmpty == false {
            textToDisplay.append(contentsOf: "This year there are \(holidays.count) holidays celebrated.\n")
        }
        
        DispatchQueue.main.async {
            self.textView.font = .systemFont(ofSize: 20)
            self.textView.text = textToDisplay
        }
    }
    
    // MARK: - Actions
    
    @IBAction func showHolidaysBtTapped(_ sender: Any) {
    }
}
