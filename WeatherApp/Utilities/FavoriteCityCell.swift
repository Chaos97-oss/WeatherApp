//
//  FavoriteCityCell.swift
//  WeatherApp
//
//  Created by Chaos on 10/8/25.
//

import Foundation
import UIKit

class FavoriteCityCell: UITableViewCell {
    static let identifier = "FavoriteCityCell"
    
    private let container = UIView()
    private let cityLabel = UILabel()
    private let tempLabel = UILabel()
    private let iconView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        
        container.layer.cornerRadius = 16
        container.clipsToBounds = true
        container.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(container)
        
        // Add gradient layer (initial placeholder)
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemBlue.cgColor, UIColor.systemTeal.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 80)
        container.layer.insertSublayer(gradient, at: 0)
        
        // Labels and icon
        cityLabel.font = .systemFont(ofSize: 20, weight: .bold)
        cityLabel.textColor = .white
        
        tempLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        tempLabel.textColor = .white
        
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .white
        
        let stack = UIStackView(arrangedSubviews: [cityLabel, tempLabel, iconView])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stack)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            
            iconView.widthAnchor.constraint(equalToConstant: 40),
            iconView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configure(city: String, temp: String?, iconName: String?) {
        cityLabel.text = city
        tempLabel.text = temp ?? "--°C"
        if let iconName = iconName {
            iconView.image = UIImage(systemName: iconName)
        } else {
            iconView.image = UIImage(systemName: "cloud.fill")
        }
    }
    
    func setGradient(colors: [UIColor]) {
        if let gradientLayer = container.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.colors = colors.map { $0.cgColor }
        }
    }
}
