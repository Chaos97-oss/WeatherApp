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
    
    func fetchWeather(for city: String, completion: @escaping (Result<Weather, Error>) -> Void) {
        weatherService.fetchWeather(for: city, completion: completion)
    }
    
    func saveFavoriteCity(_ city: String) {
        userDefaultsService.saveFavoriteCity(city)
    }
}
