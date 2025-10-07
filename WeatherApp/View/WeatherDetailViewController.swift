//
//  DetailsViewController.swift
//  WeatherApp
//
//  Created by Chaos on 10/7/25.
//

import UIKit


class WeatherDetailViewController: UIViewController {
    private let viewModel: WeatherDetailViewModel
    
    private let descriptionLabel: UILabel = UILabel()
    private let temperatureLabel: UILabel = UILabel()
    
    init(viewModel: WeatherDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
        title = "Weather Detail"
        
        descriptionLabel.text = viewModel.descriptionText
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = .systemFont(ofSize: 22)
        
        temperatureLabel.text = viewModel.temperatureText
        temperatureLabel.textAlignment = .center
        temperatureLabel.font = .systemFont(ofSize: 22)
        
        view.addSubview(descriptionLabel)
        view.addSubview(temperatureLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            
            temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            temperatureLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20)
        ])
    }
}
