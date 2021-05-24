//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Роман Мельник on 22.05.2021.
//

import IQKeyboardManager
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        window = Router.shared.window
        Router.shared.setRootVC()
        IQKeyboardManager.shared().toolbarDoneBarButtonItemText = "OK"

        return true
    }
    
}
