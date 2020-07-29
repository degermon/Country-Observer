//
//  DateRelated.swift
//  Country Observer
//
//  Created by Daniel Šuškevič on 2020-07-29.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import Foundation

enum Type {
    case thisMonth
    case upcomming
}

class DateRelated {
    
    private func getCurrentDate() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate = format.string(from: date)
        
        return formattedDate
    }
    
    func correctDateOfHolidays(list: [HolidayDetail]) -> [HolidayDetail] { // correct/cut date item of holiday to only date without time if there is any present (result mus be "yyyy-MM-dd")
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
    
    func getHolidays(forTimespan: Type, holidayList: [HolidayDetail]) -> [HolidayDetail] {
        let currentDate = getCurrentDate()
        
        let myCalendar = Calendar(identifier: .gregorian)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let currentDateFormatted = formatter.date(from: currentDate) else { return [] }
        let current = myCalendar.dateComponents([.day, .month], from: currentDateFormatted)
        
        switch forTimespan {
        case .thisMonth:
            guard let thisMonth = current.month else { return [] }
            let result = getThisMonthHolidays(currentMonth: thisMonth, allHolidays: holidayList)
            return result
        case .upcomming:
            guard let thisMonth = current.month else { return [] }
            guard let thisDay = current.day else { return [] }
            let result = getUpcomingHolidays(currentMonth: thisMonth, currentDay: thisDay, allHolidays: holidayList)
            return result
        }
    }
    
    private func getThisMonthHolidays(currentMonth: Int, allHolidays: [HolidayDetail]) -> [HolidayDetail] {
        var holidaysThisMonth: [HolidayDetail] = []
        
        for item in allHolidays {
            if let holidayMonth = getHolidayMonthDay(holiday: item).month {
                if currentMonth == holidayMonth {
                    holidaysThisMonth.append(item)
                }
            }
        }
        
        return holidaysThisMonth
    }
    
    private func getUpcomingHolidays(currentMonth: Int, currentDay: Int, allHolidays: [HolidayDetail]) -> [HolidayDetail] {
        var upcomingHolidays: [HolidayDetail] = []
        
        for item in allHolidays {
            let holidayMonthDay = getHolidayMonthDay(holiday: item)
            if let holidayMonth = holidayMonthDay.month, let holidayDay = holidayMonthDay.day {
                if holidayMonth > currentMonth {
                    upcomingHolidays.append(item)
                } else if holidayMonth == currentMonth {
                    if holidayDay >= currentDay {
                        upcomingHolidays.append(item)
                    }
                }
            }
        }
        
        return upcomingHolidays
    }
    
    private func getHolidayMonthDay(holiday: HolidayDetail) -> DateComponents {
        let myCalendar = Calendar(identifier: .gregorian)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let holidayDateString = holiday.date.iso {
            if let holidayDate = formatter.date(from: holidayDateString) {
                let holidayMonthDate = myCalendar.dateComponents([.day, .month], from: holidayDate)
                return holidayMonthDate
            }
        }
        
        return DateComponents()
    }
}
