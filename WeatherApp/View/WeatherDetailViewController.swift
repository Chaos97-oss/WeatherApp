//
//  DetailsViewController.swift
//  WeatherApp
//
//  Created by Chaos on 10/7/25.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    private let viewModel: WeatherDetailViewModel

    private let cityLabel = UILabel()
    private let tempLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let metricsStack = UIStackView()

    init(viewModel: WeatherDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Weather Details"
        view.setGradientBackground(topColor: .systemBlue, bottomColor: .white)
        setupUI()
    }

    private func setupUI() {
        // City
        cityLabel.text = viewModel.cityName
        cityLabel.font = .systemFont(ofSize: 28, weight: .bold)
        cityLabel.textAlignment = .center

        // Temperature
        tempLabel.text = viewModel.temperatureText
        tempLabel.font = .systemFont(ofSize: 60, weight: .heavy)
        tempLabel.textAlignment = .center

        // Description
        descriptionLabel.text = viewModel.descriptionText
        descriptionLabel.font = .systemFont(ofSize: 20, weight: .medium)
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .darkGray

        // Metrics icons (SF Symbols)
        let metrics = [
            createMetricRow(icon: "thermometer.sun.fill", title: viewModel.feelsLikeText),
            createMetricRow(icon: "humidity.fill", title: viewModel.humidityText),
            createMetricRow(icon: "wind", title: viewModel.windText),
            createMetricRow(icon: "cloud.sun.fill", title: viewModel.cloudText),
            createMetricRow(icon: "gauge", title: viewModel.pressureText),
            createMetricRow(icon: "sunrise.fill", title: viewModel.sunriseText),
            createMetricRow(icon: "sunset.fill", title: viewModel.sunsetText)
        ]

        metricsStack.axis = .vertical
        metricsStack.spacing = 8
        metricsStack.translatesAutoresizingMaskIntoConstraints = false

        for m in metrics { metricsStack.addArrangedSubview(m) }

        let stack = UIStackView(arrangedSubviews: [cityLabel, tempLabel, descriptionLabel, metricsStack])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func createMetricRow(icon: String, title: String) -> UIView {
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = .systemBlue
        iconView.contentMode = .scaleAspectFit
        iconView.widthAnchor.constraint(equalToConstant: 28).isActive = true

        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label

        let stack = UIStackView(arrangedSubviews: [iconView, label])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 10
        return stack
    }
}
