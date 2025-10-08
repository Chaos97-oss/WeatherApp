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
    
    let iconView = UIImageView()
    let cityLabel = UILabel()
    let tempLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.white.withAlphaComponent(0.2)
        layer.cornerRadius = 16
        clipsToBounds = true
        
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .white
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        cityLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        cityLabel.textColor = .white
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        tempLabel.font = .systemFont(ofSize: 18, weight: .medium)
        tempLabel.textColor = .white
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(iconView)
        contentView.addSubview(cityLabel)
        contentView.addSubview(tempLabel)
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 40),
            iconView.heightAnchor.constraint(equalToConstant: 40),
            
            cityLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 16),
            cityLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            tempLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tempLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError() }
}
