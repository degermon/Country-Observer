//
//  HolidayStruct.swift
//  Country Observer
//
//  Created by Daniel Šuškevič on 2020-06-25.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import Foundation

struct HolidayResponse: Decodable {
    var response: Holidays
}

struct Holidays: Decodable {
    var holidays: [HolidayDetail]
}

struct HolidayDetail: Decodable {
    var date: HolidayDate
    var description: String?
    var name: String?
}

struct HolidayDate: Decodable {
    var iso: String?
}
