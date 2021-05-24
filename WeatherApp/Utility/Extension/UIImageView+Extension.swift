//
//  UIImageView+Extension.swift
//  WeatherApp
//
//  Created by Роман Мельник on 23.05.2021.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func imageLoad(from url: URL) {
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            print("Now Fetching From Cache")
            self.image =  imageFromCache
            return
        }
        print("In Extension")
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    imageCache.setObject(image, forKey: url as AnyObject)
                    print("Now Fetching from url")
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
