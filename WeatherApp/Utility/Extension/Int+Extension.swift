//
//  Int+Extension.swift
//  WeatherApp
//
//  Created by Роман Мельник on 23.05.2021.
//

import Foundation

extension Int {
    func  dayOfWeek() -> String {
        return Date(timeIntervalSince1970: TimeInterval(self)).dayofTheWeek
    }
    
    func  fromUnixTimeToDate() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        if let retData = dateFormatter.string(for: date) {
            return retData
        }
        return ""
    }
    
    func  fromUnixTimeToTime() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        if let retData = dateFormatter.string(for: date) {
            return retData
        }
        return ""
    }
    
    func dateOnScreen() -> String {
//        formatter.dateFormat = "MMM d, h:mm:ss a"
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = ",d MMM"
        if let retData = dateFormatter.string(for: date) {
            return retData
        }
        return ""
    }
}
