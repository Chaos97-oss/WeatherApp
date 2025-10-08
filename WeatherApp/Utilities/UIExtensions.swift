//
//  AppDIContainer.swift
//  WeatherApp
//
//  Created by Chaos on 10/6/25.
//

import Foundation
import UIKit

extension UIView {

    func setGradientBackground(topColor: UIColor, bottomColor: UIColor) {
        self.layer.sublayers?.filter { $0.name == "gradientLayer" }.forEach { $0.removeFromSuperlayer() }

        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "gradientLayer"
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.locations = [0, 1]
        self.layer.insertSublayer(gradientLayer, at: 0)
    }


    func addBlurEffect(style: UIBlurEffect.Style = .systemThinMaterialLight) {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurView)
        self.sendSubviewToBack(blurView)
    }


    func makeCardStyle() {
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 8
    }
}
