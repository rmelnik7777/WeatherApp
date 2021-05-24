//
//  Router.swift
//  WeatherApp
//
//  Created by Роман Мельник on 23.05.2021.
//

import Foundation

import UIKit

final class Router: NSObject {
    
    static let shared = Router()
    var window: UIWindow?
    
    override private init() {
        super.init()
        self.window = UIWindow(frame: UIScreen.main.bounds)
    }
    
    func setRootVC() {
        window?.rootViewController = getWeatherNavVC()
        window?.makeKeyAndVisible()
    }
    
    // MARK: - Getters Navigation Controllers
    func getWeatherNavVC() -> UINavigationController? {
        return R.storyboard.weather.weatherNavVC()
    }


    // MARK: - Getters Controllers
    func getSearchCityNameVC() -> SearchCityNameVC? {
        return R.storyboard.searchCityName.searchCityNameVC()
    }


}

