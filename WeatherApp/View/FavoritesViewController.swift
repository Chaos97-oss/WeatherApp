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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorite Cities"
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.2)
        
        favorites = userDefaultsService.getFavoriteCities()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FavoriteCityCell.self, forCellReuseIdentifier: FavoriteCityCell.identifier)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favorites = userDefaultsService.getFavoriteCities()
        tableView.reloadData()
    }
    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCityCell.identifier, for: indexPath) as? FavoriteCityCell else {
            return UITableViewCell()
        }
        
        let city = favorites[indexPath.row]
        weatherService.fetchWeather(for: city) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    let temp = "\(Int(weather.main.temp))°C"
                    let iconName = sfSymbolName(for: weather.weather.first?.icon ?? "")
                    cell.configure(city: city, temp: temp, iconName: iconName)
                case .failure(_):
                    cell.configure(city: city, temp: "-", iconName: "cloud.fill")
                }
            }
        }
        return cell
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = favorites[indexPath.row]
        weatherService.fetchWeather(for: city) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    let detailVM = WeatherDetailViewModel(weather: weather)
                    let detailVC = WeatherDetailViewController(viewModel: detailVM)
                    self.navigationController?.pushViewController(detailVC, animated: true)
                case .failure(let error):
                    print(error.localizedDescription)
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
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
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
    case "10n": return "cloud.moon.rain.fill"
    case "11d", "11n": return "cloud.bolt.fill"
    case "13d", "13n": return "snow"
    case "50d", "50n": return "cloud.fog.fill"
    default: return "cloud.fill"
    }
}
