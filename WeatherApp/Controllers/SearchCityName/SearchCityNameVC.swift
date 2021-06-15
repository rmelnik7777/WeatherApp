//
//  SearchCityNameVC.swift
//  WeatherApp
//
//  Created by Роман Мельник on 23.05.2021.
//

import RxSwift
import UIKit

final class SearchCityNameVC: ViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private let viewModel = SearchCityNameVM()
    var update: (() -> ())?
    
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
                UserDefaultsHelper.shared.saveUserLatitude(self.viewModel.suggestedPlacenames.value[indexPath.row].geometry.coordinates[1])
                
                UserDefaultsHelper.shared.saveUserLongitude(self.viewModel.suggestedPlacenames.value[indexPath.row].geometry.coordinates[0])
                UserDefaultsHelper.shared.saveUserPlacesname(self.viewModel.suggestedPlacenames.value[indexPath.row].place_name ?? "NoName")
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
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchPlacesSuggestion()
    }
    
    private func cancelSearching() {
        self.searchBar.resignFirstResponder()
        self.searchBar.text = ""
        self.viewModel.suggestedPlacenames.accept([])
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func searchPlacesSuggestion() {
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
