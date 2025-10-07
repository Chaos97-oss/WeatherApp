//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Chaos on 10/7/25.
//

import UIKit

class HomeViewController: UIViewController {
    private let viewModel = HomeViewModel()
    
    private let cityTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter city name (e.g. London)"
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        tf.textAlignment = .center
        tf.clearButtonMode = .whileEditing
        return tf
    }()
    
    private let getWeatherButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Get Weather", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        btn.layer.cornerRadius = 12
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.1
        btn.layer.shadowOffset = CGSize(width: 0, height: 2)
        btn.layer.shadowRadius = 6
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let searchContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.9)
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search City"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.setGradientBackground(topColor: .systemBlue, bottomColor: .white)
        
        setupLayout()
        configureNavBar()

    }
    
    private func setupLayout() {
        view.addSubview(searchContainer)
        searchContainer.addSubview(cityTextField)
        view.addSubview(getWeatherButton)
        
        cityTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            searchContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            searchContainer.heightAnchor.constraint(equalToConstant: 70),
            
            cityTextField.leadingAnchor.constraint(equalTo: searchContainer.leadingAnchor, constant: 16),
            cityTextField.trailingAnchor.constraint(equalTo: searchContainer.trailingAnchor, constant: -16),
            cityTextField.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor),
            
            getWeatherButton.topAnchor.constraint(equalTo: searchContainer.bottomAnchor, constant: 30),
            getWeatherButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getWeatherButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            getWeatherButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        getWeatherButton.addTarget(self, action: #selector(getWeather), for: .touchUpInside)
    }
    
    private func configureNavBar() {
        let favoriteButton = UIBarButtonItem(
            image: UIImage(systemName: "star.fill"),
            style: .plain,
            target: self,
            action: #selector(openFavorites)
        )
        favoriteButton.tintColor = .systemYellow
        navigationItem.rightBarButtonItem = favoriteButton
    }
    

    
    @objc private func getWeather() {
        guard let city = cityTextField.text, !city.isEmpty else { return }
        viewModel.fetchWeather(for: city) { result in
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
    
    @objc private func openFavorites() {
        let favorites = viewModel.getFavoriteCities()
        
        if favorites.isEmpty {
            let alert = UIAlertController(
                title: "No Favorites Yet",
                message: "Search a city and tap the star ⭐️ to add one.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            let favoritesVC = FavoritesViewController()
            navigationController?.pushViewController(favoritesVC, animated: true)
        }
    }
}
