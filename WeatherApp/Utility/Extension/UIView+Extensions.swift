//
//  UIView+Extensions.swift
//  WeatherApp
//
//  Created by Роман Мельник on 15.06.2021.
//

import UIKit

extension UIView {
    func roundView(radius: CGFloat, color: UIColor? = .clear, borderWidth: CGFloat = 0) {
        layer.masksToBounds = true
        layer.cornerRadius = radius
        layer.borderWidth = borderWidth
        layer.borderColor = color?.cgColor
    }
}
