//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Chaos on 10/6/25.
//

import Foundation
struct Weather: Codable {
    let main: Main
    let weather: [WeatherDescription]
    
    struct Main: Codable {
        let temp: Double
    }
    
    struct WeatherDescription: Codable {
        let description: String
    }
}
