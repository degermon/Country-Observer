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
                self.setNavigationBarImageTitle(flagImage: resultImage ?? UIImage())
            }
        }
    }
    
    func setTitle() { // set navigation bar title (will display title until flag image is loaded, then navigation bar data will be changed)
        guard let countryName = country?.name else {
            return
        }
        self.title = countryName
    }
    
    func setNavigationBarImageTitle(flagImage: UIImage) { // as named, set country flag image and title in navigation bar
        // Only execute the code if there's a navigation controller
        if self.navigationController == nil {
            return
        }

        // Create a navView to add to the navigation bar
        let navView = UIView()

        // Create the label
        let label = UILabel()
        label.text = country?.name
        label.sizeToFit()
        label.center = navView.center
        label.textAlignment = NSTextAlignment.center

        // Create the image view
        let image = UIImageView()
        image.image = flagImage
        // To maintain the image's aspect ratio:
        let imageAspect = image.image!.size.width/image.image!.size.height
        // Setting the image frame so that it's immediately before the text:
        image.frame = CGRect(x: label.frame.origin.x-label.frame.size.height*imageAspect, y: label.frame.origin.y, width: label.frame.size.height*imageAspect, height: label.frame.size.height)
        image.contentMode = UIView.ContentMode.scaleAspectFit

        // Add both the label and image view to the navView
        navView.addSubview(label)
        navView.addSubview(image)

        // Set the navigation bar's navigation item's titleView to the navView
        self.navigationItem.titleView = navView

        // Set the navView's frame to fit within the titleView
        navView.sizeToFit()
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
