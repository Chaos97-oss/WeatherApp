//
//  DetailsViewController.swift
//  WeatherApp
//
//  Created by Chaos on 10/7/25.
//

import UIKit


class WeatherDetailViewController: UIViewController {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    var weatherText: String?
    var city: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        cityLabel.text = city ?? "—"
        detailsLabel.text = weatherText ?? "No details"
        detailsLabel.numberOfLines = 0
        detailsLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        detailsLabel.textAlignment = .center
    }
}
