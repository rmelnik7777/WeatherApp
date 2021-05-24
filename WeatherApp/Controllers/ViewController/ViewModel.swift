//
//  ViewModel.swift
//  WeatherApp
//
//  Created by Роман Мельник on 22.05.2021.
//

import Foundation
import RxSwift

class ViewModel {
    
    // MARK: - Properties
    public var loading: PublishSubject<Bool> = PublishSubject()
    public var error: PublishSubject<String> = PublishSubject()
    public let disposeBag = DisposeBag()
    
    func parseError(failure: RequestError) {
        switch failure {
        case .authorizationError(let error),.serverError(let error), .invalidRequest(let error):
            self.error.onNext(error)
        default:
            self.error.onNext(ErrorString.unknownError.rawValue)
        }
    }
}
