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
        "\(Int(round(weather.main.temp)))°C"
    }

    var feelsLikeText: String {
        if let f = weather.main.feelsLike {
            return "Feels like \(Int(round(f)))°C"
        } else {
            return "Feels like N/A"
        }
    }

    var humidityText: String {
        if let h = weather.main.humidity {
            return "Humidity: \(h)%"
        } else {
            return "Humidity: N/A"
        }
    }

    var pressureText: String {
        if let p = weather.main.pressure {
            return "Pressure: \(p) hPa"
        } else {
            return "Pressure: N/A"
        }
    }

    var windText: String {
        if let s = weather.wind?.speed {
            return String(format: "Wind: %.1f m/s", s)
        } else {
            return "Wind: N/A"
        }
    }

    var cloudText: String {
        if let c = weather.clouds?.all {
            return "Clouds: \(c)%"
        } else {
            return "Clouds: N/A"
        }
    }

    var sunriseText: String {
        if let ts = weather.sys?.sunrise {
            return "Sunrise: \(formatTime(ts))"
        } else {
            return "Sunrise: N/A"
        }
    }

    var sunsetText: String {
        if let ts = weather.sys?.sunset {
            return "Sunset: \(formatTime(ts))"
        } else {
            return "Sunset: N/A"
        }
    }

    var cityName: String {
        let parts: [String] = [weather.name, weather.sys?.country].compactMap { $0 }
        return parts.joined(separator: ", ")
    }

    var descriptionText: String {
        weather.weather.first?.description?.capitalized ?? "No description"
    }

    var numericTemperature: Double {
        weather.main.temp
    }

    init(weather: Weather) {
        self.weather = weather
    }

    private func formatTime(_ timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.timeZone = .current
        return formatter.string(from: date)
    }
}
