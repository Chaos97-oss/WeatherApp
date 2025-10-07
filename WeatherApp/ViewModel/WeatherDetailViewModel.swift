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
        "\(Int(weather.main.temp))°C"
    }
    
    var numericTemperature: Double {
        return weather.main.temp
    }
    
    var descriptionText: String {
        weather.weather.first?.description.capitalized ?? "No description"
    }
    
    var cityName: String {
        return weather.name ?? "Unknown"
    }
    
    init(weather: Weather) {
        self.weather = weather
    }
}

