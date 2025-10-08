//
//  DetailsViewController.swift
//  WeatherApp
//
//  Created by Chaos on 10/7/25.
//

import UIKit

final class WeatherDetailViewController: UIViewController {

    private let viewModel: WeatherDetailViewModel
    private let userDefaultsService = UserDefaultsService()
    
    private let cityLabel = UILabel()
    private let tempLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)

    init(viewModel: WeatherDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateBackground()
        animateLabels()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // MARK: Labels
        cityLabel.text = viewModel.cityName
        cityLabel.font = .systemFont(ofSize: 34, weight: .bold)
        cityLabel.textColor = .white
        cityLabel.textAlignment = .center
        
        tempLabel.text = viewModel.temperatureText
        tempLabel.font = .systemFont(ofSize: 60, weight: .heavy)
        tempLabel.textColor = colorForTemperature(viewModel.numericTemperature)
        tempLabel.textAlignment = .center
        
        descriptionLabel.text = viewModel.descriptionText
        descriptionLabel.font = .systemFont(ofSize: 20, weight: .medium)
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .center
        
        // MARK: Temperature + Cloud Icon Stack
        let tempStack = UIStackView()
        tempStack.axis = .horizontal
        tempStack.spacing = 8
        tempStack.alignment = .center
        tempStack.translatesAutoresizingMaskIntoConstraints = false
        
        let cloudIcon = UIImageView()
        cloudIcon.contentMode = .scaleAspectFit
        cloudIcon.tintColor = .white
        cloudIcon.image = UIImage(systemName: cloudIconName(for: viewModel.cloudsPercentage))
        cloudIcon.widthAnchor.constraint(equalToConstant: 50).isActive = true
        cloudIcon.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        tempStack.addArrangedSubview(tempLabel)
        tempStack.addArrangedSubview(cloudIcon)
        
        // MARK: Metric Grid with Improved Blur
        let gridStack = viewModel.metricGrid()
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.layer.cornerRadius = 20
        blurView.clipsToBounds = true
        blurView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.contentView.addSubview(gridStack)
        gridStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gridStack.leadingAnchor.constraint(equalTo: blurView.contentView.leadingAnchor, constant: 16),
            gridStack.trailingAnchor.constraint(equalTo: blurView.contentView.trailingAnchor, constant: -16),
            gridStack.topAnchor.constraint(equalTo: blurView.contentView.topAnchor, constant: 16),
            gridStack.bottomAnchor.constraint(equalTo: blurView.contentView.bottomAnchor, constant: -16)
        ])
        
        // MARK: Favorites Button
        favoriteButton.setTitle("Add to Favorites", for: .normal)
        favoriteButton.backgroundColor = .systemYellow
        favoriteButton.setTitleColor(.black, for: .normal)
        favoriteButton.layer.cornerRadius = 12
        favoriteButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        favoriteButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        favoriteButton.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        favoriteButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        // MARK: Scroll View
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // MARK: Content Stack
        let contentStack = UIStackView(arrangedSubviews: [
            cityLabel,
            tempStack,         
            descriptionLabel,
            blurView,
            favoriteButton
        ])
        contentStack.axis = .vertical
        contentStack.spacing = 20
        contentStack.alignment = .center
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            blurView.widthAnchor.constraint(equalTo: contentStack.widthAnchor)
        ])
    }

    // MARK: - Helper for Cloud Icon
    private func cloudIconName(for clouds: Int?) -> String {
        guard let clouds = clouds else { return "sun.max.fill" }
        switch clouds {
        case 0...20: return "sun.max.fill"
        case 21...50: return "cloud.sun.fill"
        case 51...80: return "cloud.fill"
        default: return "smoke.fill"
        }
    }
    
    // MARK: - Favorites Action
    @objc private func favoriteTapped() {
        if userDefaultsService.isFavorite(city: viewModel.cityName) {
            userDefaultsService.removeFavoriteCity(viewModel.cityName)
            favoriteButton.setTitle("Add to Favorites", for: .normal)
        } else {
            userDefaultsService.addFavoriteCity(viewModel.cityName)
            favoriteButton.setTitle("Remove from Favorites", for: .normal)
        }
    }
    
    @objc private func addToFavorites() { userDefaultsService.saveFavoriteCity(viewModel.cityName);
        let alert = UIAlertController(title: "Added", message: "\(viewModel.cityName) added to favorites.",
        preferredStyle: .alert); alert.addAction(UIAlertAction(title: "OK", style: .default)); present(alert, animated: true)
        
    }
    
    // MARK: - Helpers
    private func makeQuickStat(icon: String, text: String) -> UIView {
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = .white
        iconView.contentMode = .scaleAspectFit
        iconView.widthAnchor.constraint(equalToConstant: 22).isActive = true
        
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .white
        
        let stack = UIStackView(arrangedSubviews: [iconView, label])
        stack.axis = .horizontal
        stack.spacing = 6
        return stack
    }
    
    private func colorForTemperature(_ temp: Double) -> UIColor {
        switch temp {
        case ..<0: return .cyan
        case 0..<15: return .systemTeal
        case 15..<25: return .systemYellow
        case 25..<35: return .systemOrange
        default: return .systemRed
        }
    }
    
    private func updateBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemIndigo.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        let backgroundView = UIView(frame: view.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        backgroundView.alpha = 0.85
        view.insertSubview(backgroundView, at: 0)
    }
    
    private func animateLabels() {
        cityLabel.alpha = 0
        tempLabel.alpha = 0
        descriptionLabel.alpha = 0
        
        UIView.animate(withDuration: 1.2, delay: 0.1, options: [.curveEaseInOut]) {
            self.cityLabel.alpha = 1
            self.tempLabel.alpha = 1
            self.descriptionLabel.alpha = 1
        }
    }
}
