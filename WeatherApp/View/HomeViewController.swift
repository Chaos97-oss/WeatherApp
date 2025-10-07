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
        tf.placeholder = "Enter city"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let searchButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Get Weather", for: .normal)
        return btn
    }()
    
    private let saveButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Save Favorite", for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search City"
        view.setGradientBackground(topColor: .systemBlue, bottomColor: .white)

        // Container card for search
        let searchContainer = UIView()
        searchContainer.translatesAutoresizingMaskIntoConstraints = false
        searchContainer.backgroundColor = .white.withAlphaComponent(0.9)
        searchContainer.makeCardStyle()
        view.addSubview(searchContainer)

        let searchField = UITextField()
        searchField.placeholder = "Enter city (e.g. London)"
        searchField.borderStyle = .none
        searchField.font = UIFont.systemFont(ofSize: 18)
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchContainer.addSubview(searchField)

        NSLayoutConstraint.activate([
            searchContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            searchContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            searchContainer.heightAnchor.constraint(equalToConstant: 60),

            searchField.leadingAnchor.constraint(equalTo: searchContainer.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: searchContainer.trailingAnchor, constant: -16),
            searchField.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor)
        ])
    }
    
    private func setupLayout() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 6
        
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        [cityTextField, searchButton, saveButton].forEach { containerView.addSubview($0) }
        [cityTextField, searchButton, saveButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 300),
            containerView.heightAnchor.constraint(equalToConstant: 200),
            
            cityTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            cityTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            cityTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            cityTextField.heightAnchor.constraint(equalToConstant: 40),
            
            searchButton.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 20),
            searchButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            saveButton.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
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
    
    @objc private func saveFavorite() {
        guard let city = cityTextField.text, !city.isEmpty else { return }
        viewModel.saveFavoriteCity(city)
    }
}
