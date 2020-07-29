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
    
    private let dateRelated = DateRelated()
    private var holidayListForTB: [HolidayDetail] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        holidayListForTB = dateRelated.correctDateOfHolidays(list: holidayList)
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
    
    // MARK: - Actions
    
    @IBAction func allFilterTapped(_ sender: Any) {
        holidayListForTB = holidayList
    }
    
    @IBAction func thisMonthFilterTapped(_ sender: Any) {
        holidayListForTB = dateRelated.getHolidays(forTimespan: .thisMonth, holidayList: holidayList)
    }
    
    @IBAction func upcomingFilterTapped(_ sender: Any) {
        holidayListForTB = dateRelated.getHolidays(forTimespan: .upcomming, holidayList: holidayList)
    }
}

extension HolidaysViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return holidayListForTB.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HolidayCell", for: indexPath)
        let holiday = holidayListForTB[indexPath.row]
        
        if let name = holiday.name {
            cell.textLabel?.text = name
        }
        if let date = holiday.date.iso {
            cell.detailTextLabel?.text = date
        }
               
        return cell
    }
}
