//
//  HolidaysViewController.swift
//  Country Observer
//
//  Created by Daniel Šuškevič on 2020-06-29.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import UIKit

class HolidaysViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var holidayList: [HolidayDetail] = [] 
    var countryName: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        holidayList = correctDateOfHolidays(list: holidayList)
        configureTableView()
        setTitle()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setTitle() { // set navigation title
        if let name = countryName {
            self.title = "\(name) Holidays"
        }
    }
    
    func correctDateOfHolidays(list: [HolidayDetail]) -> [HolidayDetail] { // correct/cut date item of holiday to only date without time if there is any present
        var index = 0
        var correctedList: [HolidayDetail] = []
        for item in list {
            correctedList.append(item)
            let correctDate = item.date.iso?.prefix(10)
            correctedList[index].date.iso = String(correctDate ?? "")
            index += 1
        }
        return correctedList
    }
    
    // MARK: - Actions
    
    @IBAction func allFilterTapped(_ sender: Any) {
    }
    
    @IBAction func thisMonthFilterTapped(_ sender: Any) {
    }
    
    @IBAction func upcomingFilterTapped(_ sender: Any) {
    }
}

extension HolidaysViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return holidayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HolidayCell", for: indexPath)
        let holiday = holidayList[indexPath.row]
        
        if let name = holiday.name {
            cell.textLabel?.text = name
        }
        if let date = holiday.date.iso {
            cell.detailTextLabel?.text = date
        }
               
        return cell
    }
}
