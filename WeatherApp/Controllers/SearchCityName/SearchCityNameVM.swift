//
//  SearchCityNameVM.swift
//  WeatherApp
//
//  Created by Роман Мельник on 24.05.2021.
//

import RxCocoa
import RxSwift

final class SearchCityNameVM: ViewModel {
    
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
                        self.loading.onNext(false)
                        self.error.onNext("Error in Data Decoding")
                    }
                case .failure(let failure):
                    self.parseError(failure: failure)
                    self.loading.onNext(false)
                }
            }).disposed(by: disposeBag)
    }
}
