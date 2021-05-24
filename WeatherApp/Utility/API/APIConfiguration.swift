//
//  APIConfiguration.swift
//  WeatherApp
//
//  Created by Роман Мельник on 22.05.2021.
//  Copyright © 2020 Roman Melnyk. All rights reserved.
//

import Alamofire

struct APIConfiguration {
    static var baseURL: String {
        return "https://api.openweathermap.org/data/2.5/onecall?"
    }
    static var baseURLMap: String {
        return "https://api.mapbox.com/geocoding/v5/mapbox.places/"
    }
    
//    static var headers: HTTPHeaders {
//        var headersDict: [String: String] = [:]
//        return headersDict
//    }
}
