//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Chaos on 10/6/25.
//

import Foundation
struct Weather: Codable {
    let name: String?
    let main: Main
    let weather: [WeatherDescription]
    let wind: Wind?
    let clouds: Clouds?
    let sys: Sys?

    struct Main: Codable {
        let temp: Double
        let feelsLike: Double?
        let tempMin: Double?
        let tempMax: Double?
        let pressure: Int?
        let humidity: Int?

        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure
            case humidity
        }
    }

    struct WeatherDescription: Codable {
        let main: String?
        let description: String?
        let icon: String?
    }

    struct Wind: Codable {
        let speed: Double?
        let deg: Int?
        let gust: Double?
    }

    struct Clouds: Codable {
        let all: Int?
    }

    struct Sys: Codable {
        let country: String?
        let sunrise: Int?
        let sunset: Int?
    }
}
