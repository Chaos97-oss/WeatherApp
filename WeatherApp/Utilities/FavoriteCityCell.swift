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
    
    private let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemMaterialLight)
        let view = UIVisualEffectView(effect: blur)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = .systemYellow
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let stack: UIStackView = {
        let s = UIStackView()
        s.axis = .horizontal
        s.alignment = .center
        s.spacing = 12
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(blurView)
        blurView.contentView.addSubview(stack)
        
        stack.addArrangedSubview(cityLabel)
        stack.addArrangedSubview(tempLabel)
        stack.addArrangedSubview(iconView)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            blurView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            blurView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            blurView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            stack.topAnchor.constraint(equalTo: blurView.contentView.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: blurView.contentView.bottomAnchor, constant: -12),
            stack.leadingAnchor.constraint(equalTo: blurView.contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: blurView.contentView.trailingAnchor, constant: -16),
            
            iconView.widthAnchor.constraint(equalToConstant: 30),
            iconView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(city: String, temp: String, iconName: String) {
        cityLabel.text = city
        tempLabel.text = temp
        iconView.image = UIImage(systemName: iconName)
    }
}
