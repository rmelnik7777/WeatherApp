//
//  CustomTableViewCell.swift
//  WeatherApp
//
//  Created by Роман Мельник on 24.05.2021.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var forecastDate: UILabel!
    @IBOutlet weak var forecastWeatherIcon: UIImageView!
    @IBOutlet weak var minMaxTemp: UILabel!
    
    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
