//
//  CountryRequest.swift
//  Country Observer
//
//  Created by Daniel Šuškevič on 2020-06-25.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import UIKit

enum CountryError: Error {
    case noCountryDataAvailable
    case cannotProcessCountryData
}

class CountryRequest {
    func getCountries(completion: @escaping (Result<[Country], CountryError>) -> ()) {
        guard let resourceURL = URL(string: "https://restcountries.eu/rest/v2/all") else { fatalError() }
        
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, _  in
            guard let jsonData = data else {
                completion(.failure(.noCountryDataAvailable))
                return
            }
                
            do {
                let decoder = JSONDecoder()
                let country = try decoder.decode([Country].self, from: jsonData)
                completion(.success(country))
            } catch {
                completion(.failure(.cannotProcessCountryData))
            }
        }
        dataTask.resume()
    }
    
    func downloadImageFor(country: String, completion: @escaping (UIImage?)->()) {
        guard let resourceURL = URL(string: "https://www.countryflags.io/\(country.lowercased())/flat/64.png") else { fatalError() }
        
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { (data, error, _) in
            guard let data = data else {
                completion(UIImage())
                return
            }
            let image = UIImage(data: data)
            completion(image)
        }
        dataTask.resume()
    }
}
