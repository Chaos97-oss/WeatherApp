//
//  DetailsViewController.swift
//  WeatherApp
//
//  Created by Chaos on 10/7/25.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    private let viewModel: WeatherDetailViewModel
    
    private let descriptionLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let weatherIcon = UIImageView(image: UIImage(systemName: "cloud.sun.fill"))
    
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
        
        // Stack layout for neat vertical arrangement
        let stackView = UIStackView(arrangedSubviews: [weatherIcon, descriptionLabel, temperatureLabel])
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
    
    // MARK: - Gradient Helper
    
    private func setDynamicGradientBackground() {
        let tempValue = viewModel.numericTemperature
        
        // Decide gradient colors based on temperature range
        let gradient: (UIColor, UIColor)
        if tempValue > 25 {
            gradient = (.systemOrange, .systemRed)
        } else if tempValue < 15 {
            gradient = (.systemTeal, .systemBlue)
        } else {
            gradient = (.systemBlue, .systemGreen)
        }
        
        // Apply gradient (from our UIExtensions.swift helper)
        view.setGradientBackground(topColor: gradient.0, bottomColor: gradient.1)
    }
}
