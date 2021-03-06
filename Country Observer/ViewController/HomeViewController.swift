//
//  HomeViewController.swift
//  Country Observer
//
//  Created by Daniel Šuškevič on 2020-06-25.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import UIKit
import Network

class HomeViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var countryList = [Country]()
    private let alert = AppAlerts()
    var countryListForTB = [Country]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var coutryDataForSegue: Country?
    
// MARK: - Config
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackButtonTitle()
        startInternetconnectionMonitor()
        configureTableView()
        configureSearchBar()
        getCountryList()
    }
    
    func startInternetconnectionMonitor() {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "InternetConnectionMonitor")
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("Internet conencted")
            } else {
                DispatchQueue.main.async {
                    self.present(self.alert.noInternetConnection(), animated: true, completion: nil)
                }
            }
        }
        monitor.start(queue: queue)
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
    
    func setBackButtonTitle() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "ShowCountry") as? CountryViewController {
            destinationVC.country = countryListForTB[indexPath.row]
            tableView.deselectRow(at: indexPath, animated: true)
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
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
