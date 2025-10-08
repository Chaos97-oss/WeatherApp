//
//  DetailsViewModel.swift
//  WeatherApp
//
//  Created by Chaos on 10/6/25.
//

import Foundation
import UIKit

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
    
    var cloudsPercentage: Int? {
        return weather.clouds?.all
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

extension WeatherDetailViewModel {
    func metricGrid() -> UIStackView {
        func makeMetric(icon: String, title: String, value: String) -> UIView {
            let iconView = UIImageView(image: UIImage(systemName: icon))
            iconView.tintColor = .white
            iconView.contentMode = .scaleAspectFit
            iconView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            iconView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = .systemFont(ofSize: 14, weight: .regular)
            titleLabel.textColor = .white.withAlphaComponent(0.8)
            
            let valueLabel = UILabel()
            valueLabel.text = value
            valueLabel.font = .systemFont(ofSize: 16, weight: .semibold)
            valueLabel.textColor = .white
            
            let vertical = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
            vertical.axis = .vertical
            vertical.alignment = .center
            vertical.spacing = 2
            
            let stack = UIStackView(arrangedSubviews: [iconView, vertical])
            stack.axis = .horizontal
            stack.spacing = 8
            stack.alignment = .center
            return stack
        }
        
        let humidity = makeMetric(icon: "drop.fill", title: "Humidity", value: humidityText)
        let pressure = makeMetric(icon: "gauge.medium", title: "Pressure", value: pressureText)
        let wind = makeMetric(icon: "wind", title: "Wind", value: windText)
        let clouds = makeMetric(icon: "cloud.fill", title: "Clouds", value: cloudText)
        let sunrise = makeMetric(icon: "sunrise.fill", title: "Sunrise", value: sunriseText)
        let sunset = makeMetric(icon: "sunset.fill", title: "Sunset", value: sunsetText)
        
        let grid = UIStackView(arrangedSubviews: [humidity, pressure, wind, clouds, sunrise, sunset])
        grid.axis = .vertical
        grid.spacing = 10
        grid.alignment = .fill
        grid.distribution = .fillEqually
        
        return grid
    }
}
