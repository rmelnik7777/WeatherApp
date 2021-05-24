//
//  SearchCityNameVM.swift
//  WeatherApp
//
//  Created by Роман Мельник on 24.05.2021.
//

import Foundation
import CoreLocation
import RxCocoa
import RxSwift

class SearchCityNameVM: ViewModel {
    
    // MARK: - Properties
    public var suggestedPlacenames = BehaviorRelay(value: [Feature]())

    // MARK: - API
    
    func getCity(searchText: String) {
        self.loading.onNext(true)
        API.General.GetCity(search: searchText).request()
            .subscribe(onNext: { result in
                switch result {
                case .success(let data):
                    do {
                        let result = try JSONDecoder().decode(Response.self, from: data)
                        self.suggestedPlacenames.accept(result.features)
                        self.loading.onNext(false)
                    } catch {
                        print("Error in Data Decoding in fetchAPIData()", error)
                        self.loading.onNext(false)
                    }
                case .failure(let failure):
                    self.parseError(failure: failure)
                    self.loading.onNext(false)
                }
            }).disposed(by: disposeBag)
    }
}
