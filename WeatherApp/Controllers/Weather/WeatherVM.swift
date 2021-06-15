//
//  WeatherVM.swift
//  WeatherApp
//
//  Created by Роман Мельник on 23.05.2021.
//

import CoreLocation
import RxCocoa
import RxSwift

final class WeatherVM: ViewModel {
    
    // MARK: - Properties
    public var presentDayData = BehaviorRelay<Daily?>(value: nil)
    public var nextSevenDaysData = BehaviorRelay(value: [Daily]())
    public var hourlyData = BehaviorRelay(value:[Hourly]())
    
    private let currentDay = Date()
    private var timezoneIdentifier = ""
    var baseImageUrlString = "https://openweathermap.org/img/wn/"
    var locationManager = CLLocationManager()
    
    // MARK: - API
    func getWeather() {
        self.loading.onNext(true)
        API.General.GetWeather(latitude: UserDefaultsHelper.shared.userLatitude ?? 0, longitude: UserDefaultsHelper.shared.userLongitude ?? 0).request()
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let data):
                    
                    do {
                        let weather = try JSONDecoder().decode(WeatherData.self, from: data)
                        self?.nextSevenDaysData.accept(weather.daily)
                        self?.hourlyData.accept(weather.hourly)
                        self?.timezoneIdentifier = weather.timezone
                        self?.modifyDataFromAPIResponse()
                        self?.loading.onNext(false)
                    } catch {
                        print("Error in Data Decoding in fetchAPIData()", error)
                        self?.loading.onNext(false)
                    }
                case .failure(let failure):
                    self?.parseError(failure: failure)
                    self?.loading.onNext(false)
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
        return currentDay.dateToString(timezoneIdentifier: self.timezoneIdentifier)
    }
    
    func getLocalWeather(){
        self.loading.onNext(true)
        LocationManager.shared.setupLocationManager()
        LocationManager.shared.delegate = self
    }

}

extension WeatherVM: LocationUpdateProtocol {
    func locationDidUpdateToLocation() {
        self.loading.onNext(false)
        self.getWeather()
    }
    func hasProblem(error: String) {
        self.loading.onNext(false)
        self.error.onNext(error)
    }
}
