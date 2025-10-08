//
//  Enviroment.swift
//  WeatherApp
//
//  Created by Chaos on 10/8/25.
//

import Foundation

enum Environment {
    static var openWeatherKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "OPENWEATHER_API_KEY") as? String else {
            fatalError("OPENWEATHER_API_KEY not found in Info.plist")
        }
        return key
    }
}


