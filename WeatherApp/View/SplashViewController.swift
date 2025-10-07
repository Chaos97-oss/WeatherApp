//
//  SplashViewController.swift
//  WeatherApp
//
//  Created by Chaos on 10/7/25.
//

import UIKit

class SplashViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                let nav = UINavigationController(rootViewController: homeVC)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        }
    }
}
