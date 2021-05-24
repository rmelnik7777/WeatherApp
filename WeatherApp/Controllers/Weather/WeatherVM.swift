//
//  WeatherVM.swift
//  WeatherApp
//
//  Created by Роман Мельник on 23.05.2021.
//

import Foundation
import CoreLocation
import RxCocoa
import RxSwift

class WeatherVM: ViewModel {
    
    // MARK: - Properties
    let currentDay = Date()
    var latitude = 0.0
    var longitude = 0.0
    var timezoneIdentifier = ""
    var locationName = ""
    private var dynamicCurrentDateNTime = 0
    var currentLocation: CLLocation?
    
    public var presentDayData = BehaviorRelay<Daily?>(value: nil)
    public var nextSevenDaysData = BehaviorRelay(value: [Daily]())
    public var hourlyData = BehaviorRelay(value:[Hourly]())

  
    
    // MARK: - API
    func getWeather() {
        self.loading.onNext(true)
        API.General.GetWeather(latitude: latitude, longitude: longitude).request()
            .subscribe(onNext: { result in
                switch result {
                case .success(let data):
                    
                    do {
                        let weather = try JSONDecoder().decode(WeatherData.self, from: data)
//                        self.dynamicCurrentDateNTime = self.currentDayData.dt
                        self.nextSevenDaysData.accept(weather.daily)
                        self.hourlyData.accept(weather.hourly)
                        self.timezoneIdentifier = weather.timezone
                        self.modifyDataFromAPIResponse()
                        self.loading.onNext(false)
                    } catch {
                        print("Error in Data Decoding in fetchAPIData()", error)
                        self.loading.onNext(false)
                    }
                case .failure(let failure):
                    self.parseError(failure: failure)
                    self.loading.onNext(false)
                }
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Helpers
    private func modifyDataFromAPIResponse() {
        if !self.nextSevenDaysData.value.isEmpty {
            self.presentDayData.accept(self.nextSevenDaysData.value.first)
        }
        if !self.hourlyData.value.isEmpty {
            self.hourlyData.accept(Array(self.hourlyData.value[0...23]))
        }
    }
    
    func prepareDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = ", d MMM"
        formatter.timeZone = TimeZone(identifier: self.timezoneIdentifier)
        
        return currentDay.dayofTheWeek + formatter.string(from: Date(timeIntervalSince1970: TimeInterval(self.dynamicCurrentDateNTime)))
    }
    
    // MARK: - GeoHelper
    
    func retriveSavedLocationData(for place: String) {
        locationName = place
        latitude = UserDefaults.standard.double(forKey: "userSelectedPlacesLatitudeValue")
        longitude = UserDefaults.standard.double(forKey: "userSelectedPlacesLongitudeValue")
    }
    
    func callReverseGeoCoder() {
        let geoCoder = CLGeocoder()
        let userCurrentLocation = CLLocation(latitude: latitude, longitude: self.longitude)
        geoCoder.reverseGeocodeLocation(userCurrentLocation, completionHandler: { (placemarks, error) in

            if let _ = error {
                return
            }

            guard let placemark = placemarks?.first else {
                return
            }

            if let placeName = placemark.locality, let placeCountry =  placemark.country {
                print(placeName)
                self.locationName = "\(placeName), \(placeCountry)"
            } else {
                print("Error in callReverseGeoCoder()")
            }


        })
    }
}
