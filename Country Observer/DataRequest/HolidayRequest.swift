//
//  HolidayRequest.swift
//  Country Observer
//
//  Created by Daniel Šuškevič on 2020-06-25.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import Foundation

enum HolidayError: Error {
    case noHolidayDataAvailable
    case cannotProcessHolidayData
}

struct HolidayRequest {
    let resourceURL: URL
    let API_KEY = "f07c0eb69d863ce714c09c9bf4902057acf4d2b2" // key from https://calendarific.com
    
    init(countryCode: String) {
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy"
        let currentYear = format.string(from: date)
        
        let resourceString = "https://calendarific.com/api/v2/holidays?&api_key=\(API_KEY)&country=\(countryCode)&year=\(currentYear)"
        
        guard let resourceURL = URL(string: resourceString) else { fatalError() }
        self.resourceURL = resourceURL
    }
    
    func getHolidays (completion: @escaping (Result<[HolidayDetail], HolidayError>) -> ()) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, _  in
            guard let jsonData = data else {
                completion(.failure(.noHolidayDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let holidaysResponse = try decoder.decode(HolidayResponse.self, from: jsonData)
                let holidayDetails = holidaysResponse.response.holidays
                completion(.success(holidayDetails))
            } catch {
                completion(.failure(.cannotProcessHolidayData))
            }
        }
        dataTask.resume()
    }
}
