//
//  UIViewController+Extensions.swift
//  WeatherApp
//
//  Created by Роман Мельник on 24.05.2021.
//

import RxCocoa
import RxSwift
import UIKit

extension UIViewController {
    func showAlertView(_ title: String?, _ description: String? = nil) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: description, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Oк", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showAlertWithTitle(title: String, message: String, options: String..., completion: @escaping (Int) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, option) in options.enumerated() {
            alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                completion(index)
            }))
        }
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UIViewController: Loading {}

extension Reactive where Base: UIViewController {
    
    /// Bindable sink for `startAnimating()`, `stopAnimating()` methods.
    public var isAnimating: Binder<Bool> {
        return Binder(self.base, binding: { (vc, active) in
            if active {
                vc.startLoading()
            } else {
                vc.stopLoading()
            }
        })
    }
    
}

