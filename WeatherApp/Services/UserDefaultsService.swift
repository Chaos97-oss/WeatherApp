//
//  UserDefaultsService.swift
//  WeatherApp
//
//  Created by Chaos on 10/7/25.
//

import Foundation

protocol UserDefaultsServiceProtocol {
    func saveFavoriteCity(_ city: String)
    func getFavoriteCity() -> String?
}

class UserDefaultsService: UserDefaultsServiceProtocol {
    private let key = "favoriteCity"
    
    func saveFavoriteCity(_ city: String) {
        UserDefaults.standard.set(city, forKey: key)
    }
    
    func getFavoriteCity() -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
}
