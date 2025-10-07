//
//  UserDefaultsService.swift
//  WeatherApp
//
//  Created by Chaos on 10/7/25.
//

import Foundation

protocol UserDefaultsServiceProtocol {
    func saveFavoriteCity(_ city: String)
    func getFavoriteCities() -> [String]
    func removeFavoriteCity(_ city: String)
}

class UserDefaultsService: UserDefaultsServiceProtocol {
    private let key = "favoriteCities"
    
    func isFavorite(city: String) -> Bool {
           getFavoriteCities().contains { $0.caseInsensitiveCompare(city) == .orderedSame }
       }
       
       func addFavoriteCity(_ city: String) {
           saveFavoriteCity(city)
       }
    
    func saveFavoriteCity(_ city: String) {
        var favorites = getFavoriteCities()
        if !favorites.contains(where: { $0.caseInsensitiveCompare(city) == .orderedSame }) {
            favorites.append(city)
            UserDefaults.standard.set(favorites, forKey: key)
        }
    }
    
    func getFavoriteCities() -> [String] {
        return UserDefaults.standard.stringArray(forKey: key) ?? []
    }
    
    func removeFavoriteCity(_ city: String) {
        var favorites = getFavoriteCities()
        favorites.removeAll { $0.caseInsensitiveCompare(city) == .orderedSame }
        UserDefaults.standard.set(favorites, forKey: key)
    }
}
