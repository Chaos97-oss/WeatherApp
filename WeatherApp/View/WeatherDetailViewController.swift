//
//  DetailsViewController.swift
//  WeatherApp
//
//  Created by Chaos on 10/7/25.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    private let viewModel: WeatherDetailViewModel
    private let userDefaultsService = UserDefaultsService()
    private let descriptionLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let weatherIcon = UIImageView(image: UIImage(systemName: "cloud.sun.fill"))
    private let favoriteButton = UIButton(type: .system)
    
    init(viewModel: WeatherDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDynamicGradientBackground()
        
        title = viewModel.cityName
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "star"),
            style: .plain,
            target: self,
            action: #selector(addToFavorites)
        )
        navigationItem.rightBarButtonItem?.tintColor = .systemYellow
        setupUI()
    }
    
    private func setupUI() {
        weatherIcon.tintColor = .white
        weatherIcon.contentMode = .scaleAspectFit
        
        descriptionLabel.text = viewModel.descriptionText
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = .systemFont(ofSize: 22, weight: .medium)
        descriptionLabel.textColor = .white
        
        temperatureLabel.text = viewModel.temperatureText
        temperatureLabel.textAlignment = .center
        temperatureLabel.font = .systemFont(ofSize: 60, weight: .bold)
        temperatureLabel.textColor = .white
        
        favoriteButton.setTitle("Add to Favorites", for: .normal)
        favoriteButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        favoriteButton.tintColor = .white
        favoriteButton.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [weatherIcon, descriptionLabel, temperatureLabel, favoriteButton])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            weatherIcon.widthAnchor.constraint(equalToConstant: 120),
            weatherIcon.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    @objc private func addToFavorites() {
        userDefaultsService.saveFavoriteCity(viewModel.cityName)
        let alert = UIAlertController(title: "Added!", message: "\(viewModel.cityName) saved to favorites.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Gradient Helper
    private func setDynamicGradientBackground() {
        let tempValue = viewModel.numericTemperature
        let gradient: (UIColor, UIColor)
        if tempValue > 25 {
            gradient = (.systemOrange, .systemRed)
        } else if tempValue < 15 {
            gradient = (.systemTeal, .systemBlue)
        } else {
            gradient = (.systemBlue, .systemGreen)
        }
        view.setGradientBackground(topColor: gradient.0, bottomColor: gradient.1)
    }
}
