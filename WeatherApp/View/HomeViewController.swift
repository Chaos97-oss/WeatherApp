//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Chaos on 10/7/25.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var getWeatherButton: UIButton!
    @IBOutlet weak var saveFavoriteButton: UIButton!
    @IBOutlet weak var stackView: UIStackView! // optional if you added a stack view

    private let viewModel = HomeViewModel()
    private var lastWeatherText: String?

    private let favoriteKey = "favoriteCity"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        cityTextField.delegate = self
        weatherLabel.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let fav = UserDefaults.standard.string(forKey: favoriteKey), !fav.isEmpty {
            cityTextField.text = fav
        }
    }

    @IBAction func getWeatherButtonTapped(_ sender: UIButton) {
        cityTextField.resignFirstResponder()
        guard let city = cityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !city.isEmpty else {
            shake(view: cityTextField)
            return
        }

        setLoading(true)
        viewModel.fetchWeather(for: city) { [weak self] weatherDescription in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.setLoading(false)
                self.lastWeatherText = weatherDescription
                self.weatherLabel.text = weatherDescription
                self.showWeatherLabelAnimated()
                // Auto-navigate to details if you want:
                // self.performSegue(withIdentifier: "ShowDetails", sender: self)
            }
        }
    }

    @IBAction func saveFavoriteTapped(_ sender: UIButton) {
        guard let city = cityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !city.isEmpty else {
            shake(view: cityTextField)
            return
        }
        UserDefaults.standard.setValue(city, forKey: favoriteKey)
        animateSaveFeedback()
    }

    // MARK: - UI Helpers

    private func setupUI() {
        // Background gradient
        let topColor = UIColor(red: 0.11, green: 0.62, blue: 0.65, alpha: 1) // teal
        let bottomColor = UIColor(red: 0.08, green: 0.18, blue: 0.31, alpha: 1) // navy
        let gradient = CAGradientLayer()
        gradient.colors = [topColor.cgColor, bottomColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)

        // Text field styling
        cityTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.95)
        cityTextField.layer.cornerRadius = 10
        cityTextField.layer.masksToBounds = true
        cityTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter city",
            attributes: [.foregroundColor: UIColor.systemGray]
        )
        cityTextField.setLeftPaddingPoints(12)
        cityTextField.returnKeyType = .done

        // Buttons
        stylePrimary(button: getWeatherButton, title: "Get Weather")
        styleSecondary(button: saveFavoriteButton, title: "Save Favorite")

        // Weather label
        weatherLabel.backgroundColor = UIColor(white: 1.0, alpha: 0.9)
        weatherLabel.textColor = .black
        weatherLabel.layer.cornerRadius = 12
        weatherLabel.layer.masksToBounds = true
        weatherLabel.numberOfLines = 0
        weatherLabel.textAlignment = .center
        weatherLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        weatherLabel.alpha = 0
    }

    private func stylePrimary(button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.backgroundColor = UIColor.systemOrange
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.12
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 6
    }

    private func styleSecondary(button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
    }

    private func showWeatherLabelAnimated() {
        weatherLabel.isHidden = false
        weatherLabel.alpha = 0
        UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseOut], animations: {
            self.weatherLabel.alpha = 1
        })
    }

    private func animateSaveFeedback() {
        UIView.animate(withDuration: 0.12, animations: {
            self.saveFavoriteButton.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
        }) { _ in
            UIView.animate(withDuration: 0.12) {
                self.saveFavoriteButton.transform = .identity
            }
        }
    }

    private func setLoading(_ loading: Bool) {
        getWeatherButton.isEnabled = !loading
        saveFavoriteButton.isEnabled = !loading
        getWeatherButton.alpha = loading ? 0.6 : 1.0
        // Optionally show spinner in button
    }

    private func shake(view: UIView) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.4
        animation.values = [-8, 8, -6, 6, -3, 3, 0]
        view.layer.add(animation, forKey: "shake")
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetails",
           let dvc = segue.destination as? WeatherDetailViewController {
            dvc.weatherText = lastWeatherText
            dvc.city = cityTextField.text
        }
    }
}

// MARK: - UITextFieldDelegate
extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        getWeatherButtonTapped(getWeatherButton)
        return true
    }
}

// MARK: - Small helpers
private extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        leftView = paddingView
        leftViewMode = .always
    }
}
