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
    @IBOutlet weak var imageView: UIImageView!
    
    var country: Country?
    private var holidays: [HolidayDetail] = []
    private let countryUnwrap = SafeCountryDataUnwrap()
    
    // MARK: - Config
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle()
        getHolidays {
            self.composeText()
        }
        let countryRequest = CountryRequest()
        countryRequest.downloadImageFor(country: countryUnwrap.safelyUnwrapString(item: country?.alpha2Code)) { (resultImage) in
            DispatchQueue.main.async {
                self.imageView.image = resultImage
            }
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
    
    func composeText() {
        var textToDisplay = ""
        textToDisplay.append(contentsOf: "\(countryUnwrap.safelyUnwrapString(item: country?.name)) is a country located in \(countryUnwrap.safelyUnwrapString(item: country?.region)) and it's capital is \(countryUnwrap.safelyUnwrapString(item: country?.capital)).")
        textToDisplay.append(contentsOf:  "The short form of this country name is \(countryUnwrap.safelyUnwrapString(item: country?.alpha2Code)).\n")
        textToDisplay.append(contentsOf: "This country has a population of \(countryUnwrap.safelyUnwrapInt(item: country?.population)) people.\n")
        textToDisplay.append(contentsOf: "The currency used in this country is \(countryUnwrap.processCurrencies(currencies: country?.currencies)).\n")
        textToDisplay.append(contentsOf: "The language used in \(countryUnwrap.safelyUnwrapString(item: country?.name)) is \(countryUnwrap.processLanguages(languages: country?.languages)).\n")
        textToDisplay.append(contentsOf: "This country falls timezone is \(countryUnwrap.processTimezones(timezones: country?.timezones)).\n")
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
        if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "ShowHolidays") as? HolidaysViewController {
            destinationVC.holidayList = holidays
            destinationVC.countryName = country?.name
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
}
