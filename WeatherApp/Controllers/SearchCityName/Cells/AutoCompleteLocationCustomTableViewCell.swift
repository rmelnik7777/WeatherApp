//
//  AutoCompleteLocationCustomTableViewCell.swift
//  WeatherApp
//
//  Created by Роман Мельник on 23.05.2021.
//

import UIKit

class AutoCompleteLocationCustomTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var placeMarker: UIImageView!
    @IBOutlet weak var suggestedPlaceName: UILabel!
    
    // MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
        placeMarker.image = R.image.mapMarker()
    }
    
}
