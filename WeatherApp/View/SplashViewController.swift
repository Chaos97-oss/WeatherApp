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
        label.text = "WeatherApp 🌤"
        label.textColor = .white
        label.font = UIFont(name: "AvenirNext-BoldItalic", size: 32)
        label.alpha = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Gradient background
        view.setGradientBackground(
            topColor: UIColor.systemBlue,
            bottomColor: UIColor.systemTeal
        )

        view.addSubview(logoLabel)
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Animate logo and move to Home screen
        animateSplash()
    }
    
    private func animateSplash() {
        UIView.animate(withDuration: 1.5, delay: 0.3, options: .curveEaseInOut) {
            self.logoLabel.alpha = 1
            self.logoLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        } completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseInOut) {
                self.logoLabel.transform = .identity
            } completion: { _ in
                // Transition after animation finishes
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let homeVC = HomeViewController()
                    homeVC.title = "Weather Finder"
                    let nav = UINavigationController(rootViewController: homeVC)
                    nav.navigationBar.prefersLargeTitles = true
                    nav.modalTransitionStyle = .crossDissolve
                    nav.modalPresentationStyle = .fullScreen
                    self.present(nav, animated: true)
                }
            }
        }
    }
}
