//
//  CustomCollectionViewCell.swift
//  WeatherApp
//
//  Created by Роман Мельник on 23.05.2021.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var forecastHourlyTemp: UILabel!
    @IBOutlet weak var forecastHourlyWeatherIcon: UIImageView!
    @IBOutlet weak var forecastHourlyTime: UILabel!
    
    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        parentView.roundView(radius: 5, color: UIColor.white, borderWidth: 2)
    }
}

