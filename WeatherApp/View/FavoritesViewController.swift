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
        view.backgroundColor = .systemBackground
        
        favorites = userDefaultsService.getFavoriteCities()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FavoriteCityCell.self, forCellReuseIdentifier: FavoriteCityCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 100
        tableView.separatorStyle = .none
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
    
    // MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let city = favorites[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCityCell.identifier, for: indexPath) as! FavoriteCityCell
        
        // Show loading placeholder
        cell.configure(city: city, temp: nil, iconName: nil)
        
        // Fetch weather preview asynchronously
        weatherService.fetchWeather(for: city) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    let temp = "\(Int(round(weather.main.temp)))°C"
                    let iconName = weather.weather.first?.icon ?? "cloud.fill"
                    cell.configure(city: city, temp: temp, iconName: iconName)
                    
                    // Optional: dynamic gradient based on temperature
                    let colors: [UIColor] = {
                        let temp = weather.main.temp
                        switch temp {
                        case ..<0: return [.cyan, .systemBlue]
                        case 0..<15: return [.systemTeal, .systemBlue]
                        case 15..<25: return [.systemYellow, .systemOrange]
                        default: return [.systemOrange, .systemRed]
                        }
                    }()
                    cell.setGradient(colors: colors)
                    
                case .failure:
                    cell.configure(city: city, temp: "--°C", iconName: "cloud.fill")
                }
            }
        }
        return cell
    }
    
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
