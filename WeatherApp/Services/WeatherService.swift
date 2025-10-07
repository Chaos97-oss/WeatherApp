//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Chaos on 10/6/25.
//

import Foundation

protocol WeatherServiceProtocol {
    func fetchWeather(for city: String, completion: @escaping (Result<Weather, Error>) -> Void)
}

class WeatherService: WeatherServiceProtocol {
    private let apiKey = "YOUR_OPENWEATHER_API_KEY"
    
    func fetchWeather(for city: String, completion: @escaping (Result<Weather, Error>) -> Void) {
        let cityEscaped = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityEscaped)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error { completion(.failure(error)); return }
            guard let data = data else { return }
            do {
                let weather = try JSONDecoder().decode(Weather.self, from: data)
                completion(.success(weather))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
