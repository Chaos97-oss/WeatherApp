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
        title = "Home"
        view.backgroundColor = .systemGreen
        setupLayout()
        
        if let favorite = viewModel.favoriteCity {
            cityTextField.text = favorite
        }
        
        searchButton.addTarget(self, action: #selector(getWeather), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveFavorite), for: .touchUpInside)
    }
    
    private func setupLayout() {
        view.addSubview(cityTextField)
        view.addSubview(searchButton)
        view.addSubview(saveButton)
        
        cityTextField.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cityTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            cityTextField.widthAnchor.constraint(equalToConstant: 250),
            
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 20),
            
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 20)
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
