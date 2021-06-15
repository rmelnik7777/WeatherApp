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
    

    // MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        UserDefaultsHelper.shared.userPlacesname == nil ? viewModel.getLocalWeather() : viewModel.getWeather()
        
    }

    // MARK: - Binding
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
                    let url = URL(string: self.viewModel.baseImageUrlString + item.weather[0].icon + ".png")
                    self.presentDayWeatherIcon.imageLoad(from: url!)
                }
                self.locationNameLabel.text = UserDefaultsHelper.shared.userPlacesname
            })
            .disposed(by: disposeBag)
        viewModel.hourlyData
            .bind(to: collectionView.rx.items(cellIdentifier: R.reuseIdentifier.customCollectionViewCell.identifier, cellType: CustomCollectionViewCell.self)) { row, item, cell in
                    cell.forecastHourlyTemp.text = "\(item.temp)°C"
                cell.forecastHourlyTime.text = item.dt.fromUnixTimeToTime()

                let urlString = self.viewModel.baseImageUrlString + item.weather[0].icon + ".png"
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
                    let url = URL(string: self.viewModel.baseImageUrlString + item.weather[0].icon + ".png")
                    cell.forecastWeatherIcon.imageLoad(from: url!)
                }
                
                cell.minMaxTemp.text = "\(item.temp.min)°/\(item.temp.max)°"
                
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Actions
    @IBAction func showCityListButtonTapped(_ sender: Any) {
        guard let vc = Router.shared.getSearchCityNameVC() else {return}
        vc.update = { [weak self] in
            self?.viewModel.getWeather()
        }
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func currentLocationTapped(_ sender: Any) {
        self.viewModel.getLocalWeather()
    }
   
}


