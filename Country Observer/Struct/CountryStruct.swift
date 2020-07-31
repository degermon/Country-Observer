//
//  CountryStruct.swift
//  Country Observer
//
//  Created by Daniel Šuškevič on 2020-06-25.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import Foundation

struct Country: Decodable {
    var alpha2Code: String?
    var capital: String?
    var currencies: [Currency]
    var languages: [Language]
    var name: String?
    var population: Int?
    var region: String?
    var timezones: [String?]
}

struct Currency: Decodable {
    var code: String?
    var name: String?
    var symbol: String?
}

struct Language: Decodable {
    var name: String?
}
