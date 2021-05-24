//
//  API.swift
//  WeatherApp
//
//  Created by Роман Мельник on 22.05.2021.
//  Copyright © 2020 Roman Melnyk. All rights reserved.
//

import Alamofire

struct API {    
    struct General {
        struct GetWeather: APIRequest {
            let latitude: Double
            let longitude: Double
       
            var httpMethod: HTTPMethod { return .get }
            var requestURL: String { return  "\(APIConfiguration.baseURL)lat=\(latitude)&lon=\(longitude)&units=metric&exclude=minutely,alerts&appid=\(Constants.KeysAPI.APIKEY_OPENWEATHERMAP)" }
                var parameters: [String: Any]? {
                    return [:]
                }
            }
    
        struct GetCity: APIRequest {
            let search: String
       
            var httpMethod: HTTPMethod { return .get }
            var requestURL: String { return  "\(APIConfiguration.baseURLMap)\(search).json?access_token=\(Constants.KeysAPI.APIKEY_MAPBOX)" }
                var parameters: [String: Any]? {
                    return [:]
                }
            }
    }
        
}
