//
//  CountryRequest.swift
//  Country Observer
//
//  Created by Daniel Šuškevič on 2020-06-25.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import Foundation

enum CountryError: Error {
    case noDataAvailable
    case cannotProcessData
}
class CountryRequest {
    func getCountries(completion: @escaping (Result<[Country], CountryError>) -> ()) {
        guard let resourceURL = URL(string: "https://restcountries.eu/rest/v2/all") else { fatalError() }
        
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, _  in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
                
            do {
                let decoder = JSONDecoder()
                let country = try decoder.decode([Country].self, from: jsonData)
                completion(.success(country))
            } catch {
                completion(.failure(.cannotProcessData))
            }
        }
        dataTask.resume()
    }
}
