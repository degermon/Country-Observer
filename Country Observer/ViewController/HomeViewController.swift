//
//  HomeViewController.swift
//  Country Observer
//
//  Created by Daniel Šuškevič on 2020-06-25.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var countryList = [Country]()
    var countryListForTB = [Country]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
// MARK: - Config
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureSearchBar()
        getCountryList()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configureSearchBar() {
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.returnKeyType = .done
    }
    
    func getCountryList() {
        let country = CountryRequest()
        country.getCountries { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let countryList):
                self?.countryList = countryList
                self?.countryListForTB = countryList
            }
        }
    }
}

// MARK: - TableView

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryListForTB.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        let country = countryListForTB[indexPath.row]
        guard let countryName = country.name else { return UITableViewCell() }
        
        cell.textLabel?.text = countryName
        
        return cell
    }
}

// MARK: - SearchBar

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count != 0 {
            countryListForTB = []
            
            for item in countryList {
                if let name = item.name?.lowercased() {
                    if name.contains(searchText.lowercased()) {
                        countryListForTB.append(item)
                    }
                }
            }
        } else {
            countryListForTB = countryList
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
