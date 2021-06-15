//
//  UserDefaultsHelper.swift
//  WeatherApp
//
//  Created by Роман Мельник on 14.06.2021.
//

import Foundation

class UserDefaultsHelper: NSObject {
    
    static let shared = UserDefaultsHelper()
    
    private let userDefaults = UserDefaults.standard
    
    private let kUserLatitude = "userSelectedPlacesLatitudeValue"
    private let kUserLongitude = "userSelectedPlacesLongitudeValue"
    private let kUserPlacesname = "userSelectedPlacesnameValue"
        
    // MARK: - UserLatitude

    var userLatitude: Double? {
        return userDefaults.value(forKey: kUserLatitude) as? Double
    }
    
    func saveUserLatitude(_ value: Double) {
        userDefaults.setValue(value, forKey: kUserLatitude)
    }
    
    func removeUserLatitude() {
        userDefaults.removeObject(forKey: kUserLatitude)
    }
    
    // MARK: - UserLongitude

    var userLongitude: Double? {
        return userDefaults.value(forKey: kUserLongitude) as? Double
    }
    
    func saveUserLongitude(_ value: Double) {
        userDefaults.setValue(value, forKey: kUserLongitude)
    }
    
    func removeUserLongitude() {
        userDefaults.removeObject(forKey: kUserLongitude)
    }
    
    // MARK: - UserPlacesname

    var userPlacesname: String? {
        return userDefaults.value(forKey: kUserPlacesname) as? String
    }
    
    func saveUserPlacesname(_ value: String) {
        userDefaults.setValue(value, forKey: kUserPlacesname)
    }
    
    func removeUserPlacesname() {
        userDefaults.removeObject(forKey: kUserPlacesname)
    }
    
}

