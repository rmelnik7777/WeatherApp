//
//  Date+Extension.swift
//  WeatherApp
//
//  Created by Роман Мельник on 23.05.2021.
//

import UIKit

extension Date {
    var dayofTheWeek: String {
        let dayNumber = Calendar.current.component(.weekday, from: self)

        
        return daysOfTheWeek[dayNumber - 1]
    }

    private var daysOfTheWeek: [String] {
        return  ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
     }
    
    func dateToString(timezoneIdentifier: String) -> String {
        let day = self.dayofTheWeek
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = ", d MMM"
        dateFormatter.timeZone = TimeZone(identifier: timezoneIdentifier)
        let string = dateFormatter.string(from: self)
        return day + string
    }
}
