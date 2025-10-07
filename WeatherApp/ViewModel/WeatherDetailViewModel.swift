//
//  DetailsViewModel.swift
//  WeatherApp
//
//  Created by Chaos on 10/6/25.
//

import Foundation
class WeatherDetailViewModel {
    private let weather: Weather
    
    var temperatureText: String {
        "\(weather.main.temp) °C"
    }
    
    var descriptionText: String {
        weather.weather.first?.description.capitalized ?? "No description"
    }
    
    init(weather: Weather) {
        self.weather = weather
    }
}
