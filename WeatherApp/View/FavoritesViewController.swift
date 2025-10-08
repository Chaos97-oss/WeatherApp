//
//  FavoritesViewController.swift
//  WeatherApp
//
//  Created by Chaos on 10/7/25.
//

import Foundation
import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView()
    private let userDefaultsService = UserDefaultsService()
    private let weatherService = WeatherService()
    
    private var favorites: [String] = []
    private var cachedWeather: [String: Weather] = [:] // cache weather per city
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorite Cities"
        
        // Blur background
        let blurEffect = UIBlurEffect(style: .systemMaterialLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurView)
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(FavoriteCityCell.self, forCellReuseIdentifier: FavoriteCityCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
        
        favorites = userDefaultsService.getFavoriteCities()
        preloadWeather()
    }
    
    private func preloadWeather() {
        for city in favorites {
            weatherService.fetchWeather(for: city) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let weather):
                        self?.cachedWeather[city] = weather
                        self?.tableView.reloadData()
                    case .failure:
                        break
                    }
                }
            }
        }
    }
    
    // MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let city = favorites[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCityCell.identifier, for: indexPath) as! FavoriteCityCell
        cell.cityLabel.text = city
        
        if let weather = cachedWeather[city], let icon = weather.weather.first?.icon {
            cell.iconView.image = UIImage(systemName: sfSymbolName(for: icon))
            cell.tempLabel.text = "\(Int(weather.main.temp))°"
        } else {
            cell.iconView.image = UIImage(systemName: "cloud.fill")
            cell.tempLabel.text = "--°"
        }
        cell.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = favorites[indexPath.row]
        if let weather = cachedWeather[city] {
            let detailVM = WeatherDetailViewModel(weather: weather)
            let detailVC = WeatherDetailViewController(viewModel: detailVM)
            navigationController?.pushViewController(detailVC, animated: true)
        } else {
            weatherService.fetchWeather(for: city) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let weather):
                        self?.cachedWeather[city] = weather
                        let detailVM = WeatherDetailViewModel(weather: weather)
                        let detailVC = WeatherDetailViewController(viewModel: detailVM)
                        self?.navigationController?.pushViewController(detailVC, animated: true)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let city = favorites[indexPath.row]
            userDefaultsService.removeFavoriteCity(city)
            favorites.remove(at: indexPath.row)
            cachedWeather.removeValue(forKey: city)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Helper to map icon
    private func sfSymbolName(for weatherIcon: String) -> String {
        switch weatherIcon {
        case "01d": return "sun.max.fill"
        case "01n": return "moon.fill"
        case "02d": return "cloud.sun.fill"
        case "02n": return "cloud.moon.fill"
        case "03d", "03n": return "cloud.fill"
        case "04d", "04n": return "smoke.fill"
        case "09d", "09n": return "cloud.drizzle.fill"
        case "10d": return "cloud.sun.rain.fill"
        case "11d", "11n": return "cloud.bolt.fill"
        case "13d", "13n": return "snow"
        case "50d", "50n": return "cloud.fog.fill"
        default: return "cloud.fill"
        }
    }
}
