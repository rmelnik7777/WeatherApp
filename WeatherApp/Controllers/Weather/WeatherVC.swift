//
//  WeatherVC.swift
//  WeatherApp
//
//  Created by Роман Мельник on 22.05.2021.
//

import RxCocoa
import RxSwift
import UIKit
import CoreLocation

class WeatherVC: ViewController {

    // MARK: - Outlets
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var presentDayDateNTime: UILabel!
    @IBOutlet weak var presentDayTempLabel: UILabel!
    @IBOutlet weak var presentDayHumLabel: UILabel!
    @IBOutlet weak var presentDayWindLabel: UILabel!
    @IBOutlet weak var presentDayWeatherIcon: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private let viewModel = WeatherVM()
    var locationManager = CLLocationManager()

    // MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let userSearchedLocationName = UserDefaults.standard.string(forKey: "userSelectedPlacesnameValue") {
            viewModel.retriveSavedLocationData(for: userSearchedLocationName)
        } else {
            checkLocationServies()
        }
        
        viewModel.getWeather()
        setupBindings()
    }


    private func setupBindings() {
        viewModel.loading
            .bind(to: self.rx.isAnimating).disposed(by: disposeBag)
        
        viewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (error) in
                self?.showAlertView(error)
            })
            .disposed(by: disposeBag)
        viewModel.presentDayData
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self]  item in
                guard let self = self, let item = item else { return }
                
                self.presentDayDateNTime.text = self.viewModel.prepareDate()
                self.presentDayTempLabel.text = "\(item.temp.day)°"
                self.presentDayHumLabel.text = "\(item.humidity)%"
                self.presentDayWindLabel.text = "\(item.wind_speed) м/сек"
                if !item.weather.isEmpty {
                    let url = URL(string: "https://openweathermap.org/img/wn/" + item.weather[0].icon + ".png")
                    self.presentDayWeatherIcon.imageLoad(from: url!)
                }
                self.locationNameLabel.text = self.viewModel.locationName
            })
            .disposed(by: disposeBag)
        viewModel.hourlyData
            .bind(to: collectionView.rx.items(cellIdentifier: R.reuseIdentifier.customCollectionViewCell.identifier, cellType: CustomCollectionViewCell.self)) { row, item, cell in
                    cell.forecastHourlyTemp.text = "\(item.temp)°C"
                cell.forecastHourlyTime.text = item.dt.fromUnixTimeToTime()

                let urlString = "https://openweathermap.org/img/wn/" + item.weather[0].icon + ".png"
                if let url = URL(string: urlString) {
                    cell.forecastHourlyWeatherIcon.imageLoad(from: url)
                } else {
                    print("Error in URL() in collectionView - cellForItemAt indexPath")
                }
                
            }
            .disposed(by: disposeBag)

        viewModel.nextSevenDaysData
            .bind(to: tableView.rx.items(cellIdentifier: R.reuseIdentifier.customTableViewCell.identifier, cellType: CustomTableViewCell.self)) { row, item, cell in
                cell.forecastDate.text = "\(item.dt.dayOfWeek())"
                if !item.weather.isEmpty {
                    let url = URL(string: "https://openweathermap.org/img/wn/" + item.weather[0].icon + ".png")
                    cell.forecastWeatherIcon.imageLoad(from: url!)
                }
                
                cell.minMaxTemp.text = "\(item.temp.min)°/\(item.temp.max)°"
                
            }
            .disposed(by: disposeBag)
    }

    @IBAction func showCityListButtonTapped(_ sender: Any) {
        guard let vc = Router.shared.getSearchCityNameVC() else {return}
        vc.update = { [weak self] in
            guard let userSearchedLocationName = UserDefaults.standard.string(forKey: "userSelectedPlacesnameValue") else { return }
            self?.viewModel.retriveSavedLocationData(for: userSearchedLocationName)
            self?.viewModel.getWeather()
        }
        present(vc, animated: true, completion: nil)
    }
}

// MARK:- Location Feteching Part
extension WeatherVC: CLLocationManagerDelegate {
    
    func checkLocationServies() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            checkLocationAuthorization()
        } else {
            self.showAlertView("Turn on Location Services", "Please Turn \"Location Services\" On From \"Settings -> Privacy -> Location Services -> Location Sevices\".")
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.requestLocation()
            break
        case .denied:
            self.showAlertView("Turn on Location Access For this App","Please Turn \"Location Access Permission\" On From \"Settings -> Privacy -> Location Services -> OpenWeatherApp -> While Using the App\".")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            self.showAlertView("Restricted By User", "This is possibly due to active restrictions such as parental controls being in place.")
        case .authorizedAlways:
            locationManager.requestLocation()
        default:
            self.showAlertView("Unknown Case!","This Permission is not handled in developing time.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        viewModel.currentLocation = locations.last

        if let lat = viewModel.currentLocation?.coordinate.latitude {
            self.viewModel.latitude = lat
            print("CLLocationManager - Latitude: ", self.viewModel.latitude)
        }

        if let lon = viewModel.currentLocation?.coordinate.longitude {
            self.viewModel.longitude = lon
            print("CLLocationManager - Longitude: ", self.viewModel.longitude)
        }
        self.viewModel.callReverseGeoCoder()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.showAlertView("Error in Fetching Location", "Error Occured: \(error). Please Check Your Location On the Settings -> Privacy -> Location Services")
    }
    
 

}
