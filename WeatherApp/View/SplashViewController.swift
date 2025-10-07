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
        navigateToHome()
    }

    private func navigateToHome() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as? HomeViewController {
                self.navigationController?.pushViewController(homeVC, animated: true)
            }
        }
    }
}
