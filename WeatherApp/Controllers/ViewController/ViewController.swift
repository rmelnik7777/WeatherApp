//
//  ViewController.swift
//  WeatherApp
//
//  Created by Роман Мельник on 22.05.2021.
//

import RxSwift
import SVProgressHUD
import UIKit

protocol Loading {
    func startLoading()
    func stopLoading()
}

extension Loading where Self : UIViewController {
    func startLoading() {
        DispatchQueue.main.async(execute: {
            SVProgressHUD.show()
        })
    }
    func stopLoading() {
        DispatchQueue.main.async(execute: {
            SVProgressHUD.dismiss()
        })
    }
}

class ViewController: UIViewController {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    


}
