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
        view.backgroundColor = .systemBackground
        title = "Weather Details"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        weatherIcon.tintColor = .systemOrange
        weatherIcon.contentMode = .scaleAspectFit
        
        descriptionLabel.text = viewModel.descriptionText
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = .systemFont(ofSize: 22, weight: .medium)
        
        temperatureLabel.text = viewModel.temperatureText
        temperatureLabel.textAlignment = .center
        temperatureLabel.font = .systemFont(ofSize: 30, weight: .bold)
        
        [weatherIcon, descriptionLabel, temperatureLabel].forEach { view.addSubview($0) }
        [weatherIcon, descriptionLabel, temperatureLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            weatherIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            weatherIcon.widthAnchor.constraint(equalToConstant: 100),
            weatherIcon.heightAnchor.constraint(equalToConstant: 100),
            
            descriptionLabel.topAnchor.constraint(equalTo: weatherIcon.bottomAnchor, constant: 20),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            temperatureLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
