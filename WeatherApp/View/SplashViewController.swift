//
//  SplashViewController.swift
//  WeatherApp
//
//  Created by Chaos on 10/7/25.
//

import UIKit

class SplashViewController: UIViewController {
    
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "WeatherApp"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 30)
        label.alpha = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBlue
        
        view.addSubview(logoLabel)
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Animate logo fade-in
        UIView.animate(withDuration: 1.0, animations: {
            self.logoLabel.alpha = 1.0
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                let homeVC = HomeViewController()
                let nav = UINavigationController(rootViewController: homeVC)
                nav.modalPresentationStyle = .fullScreen
                nav.navigationBar.prefersLargeTitles = true
                self.present(nav, animated: true)
            }
        }
    }
}
