//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Chaos on 10/6/25.
//

import Foundation

class HomeViewModel {
    private let weatherService: WeatherServiceProtocol
    private let userDefaultsService: UserDefaultsServiceProtocol
    
    var favoriteCity: String? {
        userDefaultsService.getFavoriteCity()
    }
    
    init(weatherService: WeatherServiceProtocol = WeatherService(),
         userDefaultsService: UserDefaultsServiceProtocol = UserDefaultsService()) {
        self.weatherService = weatherService
        self.userDefaultsService = userDefaultsService
    }
    
    func fetchWeather(for city: String, completion: @escaping (String) -> Void) {
            weatherService.fetchWeather(for: city) { result in
                switch result {
                case .success(let weather):
                    let description = weather.weather.first?.description.capitalized ?? "No description"
                    let temperature = String(format: "%.1f°C", weather.main.temp)
                    let weatherText = "\(description), \(temperature)"
                    completion(weatherText)
                case .failure(let error):
                    completion("Error: \(error.localizedDescription)")
                }
            }
        }
    
    func saveFavoriteCity(_ city: String) {
        userDefaultsService.saveFavoriteCity(city)
    }
}
