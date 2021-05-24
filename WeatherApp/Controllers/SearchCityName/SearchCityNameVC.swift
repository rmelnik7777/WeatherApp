//
//  SearchCityNameVC.swift
//  WeatherApp
//
//  Created by Роман Мельник on 23.05.2021.
//

import RxCocoa
import RxSwift
import UIKit

class SearchCityNameVC: ViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private let viewModel = SearchCityNameVM()
    var update: (() -> ())?

    var isSearchActive = false

//    var userSelectedPlacesLatitude: Double = 0
//    var userSelectedPlacesLongitude: Double = 0
    var userSelectedPlacesname = ""
    
    // MARK:- viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        searchBar.delegate = self
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
        
        viewModel.suggestedPlacenames
            .bind(to: tableView.rx.items(cellIdentifier: R.reuseIdentifier.autoCompleteLocationCustomTableViewCell.identifier, cellType: AutoCompleteLocationCustomTableViewCell.self)) { row, item, cell in
                cell.suggestedPlaceName.text = item.place_name!
            }
            .disposed(by: disposeBag)
    
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
//                self.userSelectedPlacesLatitude = self.viewModel.suggestedPlacenames.value[indexPath.row].geometry.coordinates[1]
                UserDefaults.standard.set(self.viewModel.suggestedPlacenames.value[indexPath.row].geometry.coordinates[1], forKey: "userSelectedPlacesLatitudeValue")

//                self.userSelectedPlacesLongitude = self.viewModel.suggestedPlacenames.value[indexPath.row].geometry.coordinates[0]
                UserDefaults.standard.set(self.viewModel.suggestedPlacenames.value[indexPath.row].geometry.coordinates[0], forKey: "userSelectedPlacesLongitudeValue")

                self.userSelectedPlacesname = self.viewModel.suggestedPlacenames.value[indexPath.row].place_name ?? "Error"
                UserDefaults.standard.set(self.userSelectedPlacesname, forKey: "userSelectedPlacesnameValue")
                self.update!()
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

    // MARK:- SearchBar Delegate Functions
extension SearchCityNameVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.cancelSearching()
        self.isSearchActive = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.searchPlacesSuggestion), object: nil)
        
        self.perform(#selector(self.searchPlacesSuggestion), with:nil, afterDelay: 0.5)
            isSearchActive = (searchBar.text?.isEmpty) == nil
    }
    
    func cancelSearching() {
        isSearchActive = false
        self.searchBar.resignFirstResponder()
        self.searchBar.text = ""
        self.viewModel.suggestedPlacenames.accept([])
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func searchPlacesSuggestion() {
        if let userTypedName = searchBar.text {
            if(!userTypedName.isEmpty) {
                let trimmedUserTypedName = userTypedName.trimmingCharacters(in: .whitespacesAndNewlines)
                self.viewModel.getCity(searchText: trimmedUserTypedName)
            }
        } else {
            print("Error in searchPlacesSuggestion()")
        }
    }
}
