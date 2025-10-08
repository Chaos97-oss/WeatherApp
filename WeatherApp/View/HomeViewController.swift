//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Chaos on 10/7/25.
//

import UIKit
import MapKit

class HomeViewController: UIViewController {

    private let viewModel = HomeViewModel()
    
    // MARK: - UI Elements
    private let searchContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.9)
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let cityTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter city name (e.g. London)"
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        tf.textAlignment = .center
        tf.clearButtonMode = .whileEditing
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let getWeatherButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Get Weather", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        btn.layer.cornerRadius = 12
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.1
        btn.layer.shadowOffset = CGSize(width: 0, height: 2)
        btn.layer.shadowRadius = 6
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let searchTableView = UITableView()
    private var searchResults: [MKLocalSearchCompletion] = []
    private let searchCompleter = MKLocalSearchCompleter()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.setGradientBackground(topColor: .systemBlue, bottomColor: .white)
        setupBlurBackground()
            setupClouds()
        setupLayout()
        configureNavBar()
        setupSearchCompleter()
    }
    
    // MARK: - Background & Effects

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.subviews
            .filter { $0.tag == 999 }
            .forEach { $0.removeFromSuperview() }

        setupClouds()
    }

    
    private func setupBlurBackground() {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.alpha = 0.7
        view.insertSubview(blurView, at: 1)
    }

    private func setupClouds() {
        let cloudImageNames = ["cloud1", "cloud2"]
        let cloudCount = 20

        // Make sure blur stays above clouds
        if let blurView = view.subviews.first(where: { $0 is UIVisualEffectView }) {
            for _ in 0..<cloudCount {
                let cloudName = cloudImageNames.randomElement() ?? "cloud1"
                let cloud = UIImageView(image: UIImage(named: cloudName))
                cloud.tag = 999
                cloud.alpha = CGFloat.random(in: 0.2...0.5)
                cloud.contentMode = .scaleAspectFit

                let width = CGFloat.random(in: 80...150)
                let height = width * 0.6
                cloud.frame = CGRect(
                    x: CGFloat.random(in: -200...view.frame.width),
                    y: CGFloat.random(in: 50...250),
                    width: width,
                    height: height
                )

                cloud.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
                // Insert just *below* the blur effect
                view.insertSubview(cloud, belowSubview: blurView)
                animateCloud(cloud)
            }
        }
    }

    private func animateCloud(_ cloud: UIImageView) {
        let screenWidth = view.frame.width
        let duration = Double.random(in: 20...50)
        let delay = Double.random(in: 4...10) // staggered start

        // Start animation
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: [.repeat, .curveLinear],
            animations: {
                cloud.frame.origin.x = screenWidth + cloud.frame.width
            },
            completion: { _ in
                cloud.frame.origin.x = -cloud.frame.width
            }
        )
    }
    
    // MARK: - Layout
    private func setupLayout() {
        // Create vertical stack for search bar + button
        let mainStack = UIStackView(arrangedSubviews: [searchContainer, getWeatherButton])
        mainStack.axis = .vertical
        mainStack.spacing = 30
        mainStack.alignment = .center
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStack)
        
        // Add city text field inside search container
        searchContainer.addSubview(cityTextField)
        
        cityTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cityTextField.leadingAnchor.constraint(equalTo: searchContainer.leadingAnchor, constant: 16),
            cityTextField.trailingAnchor.constraint(equalTo: searchContainer.trailingAnchor, constant: -16),
            cityTextField.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor)
        ])
        
        // Center the stack in the view
        NSLayoutConstraint.activate([
            mainStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            searchContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            searchContainer.heightAnchor.constraint(equalToConstant: 70),
            getWeatherButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            getWeatherButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Add target for button
        getWeatherButton.addTarget(self, action: #selector(getWeather), for: .touchUpInside)
        
        // Setup search suggestions table
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchCell")
        searchTableView.layer.cornerRadius = 12
        searchTableView.layer.masksToBounds = true
        searchTableView.isHidden = true
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchTableView)
        
        NSLayoutConstraint.activate([
            searchTableView.topAnchor.constraint(equalTo: searchContainer.bottomAnchor, constant: 4),
            searchTableView.leadingAnchor.constraint(equalTo: searchContainer.leadingAnchor),
            searchTableView.trailingAnchor.constraint(equalTo: searchContainer.trailingAnchor),
            searchTableView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        cityTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    // MARK: - Search Completer
    private func setupSearchCompleter() {
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
    }
    
    @objc private func textDidChange() {
        guard let query = cityTextField.text else { return }
        searchCompleter.queryFragment = query
        searchTableView.isHidden = query.isEmpty
    }
    
    // MARK: - NavBar
    private func configureNavBar() {
        let favoriteButton = UIBarButtonItem(
            image: UIImage(systemName: "star.fill"),
            style: .plain,
            target: self,
            action: #selector(openFavorites)
        )
        favoriteButton.tintColor = .systemYellow
        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    // MARK: - Actions
    @objc private func getWeather() {
        guard let city = cityTextField.text, !city.isEmpty else { return }
        fetchWeather(for: city)
    }
    
    @objc private func openFavorites() {
        let favorites = viewModel.getFavoriteCities()
        if favorites.isEmpty {
            let alert = UIAlertController(title: "No Favorites Yet",
                                          message: "Search a city and Add Yours.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            let favoritesVC = FavoritesViewController()
            navigationController?.pushViewController(favoritesVC, animated: true)
        }
    }
    
    private func fetchWeather(for city: String) {
        viewModel.fetchWeather(for: city) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    let detailVM = WeatherDetailViewModel(weather: weather)
                    let detailVC = WeatherDetailViewController(viewModel: detailVM)
                    self.navigationController?.pushViewController(detailVC, animated: true)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - MKLocalSearchCompleterDelegate
extension HomeViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Search completer error: \(error.localizedDescription)")
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        let result = searchResults[indexPath.row]
        cell.textLabel?.text = result.title
        cell.detailTextLabel?.text = result.subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = searchResults[indexPath.row].title
        cityTextField.text = city
        searchTableView.isHidden = true
        fetchWeather(for: city)
    }
}
