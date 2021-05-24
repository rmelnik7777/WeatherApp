import Alamofire
import RxSwift

protocol APIRequest {
    var httpMethod: HTTPMethod { get }
    var requestURL: String { get }
    var parameters: [String: Any]? { get }
}

enum ApiResult {
    case success (Data)
    case failure(RequestError)
}

enum RequestError {
    case unknownError(String)
    case connectionError(String)
    case authorizationError(String)
    case invalidRequest(String)
    case notFound(String)
    case invalidResponse(String)
    case serverError(String)
    case serverUnavailable(String)
    case unauthenticated(String)
}

enum ErrorString: String {
    case unknownError = "Internal error. Try again"
    case serverError = "Server error"
}
    
extension APIRequest {
    
    func request() -> Observable<ApiResult> {
        return Observable.create { observer in

            let request = AF.request(self.requestURL, method: self.httpMethod, parameters: parameters)
            request.responseString { response -> Void in
                switch response.result {
                case .success( _):
                    if let httpCode = response.response?.statusCode, let data = response.data {
                        switch httpCode {
                        case 200:
                            print("в случае успешного выполнения")
                            observer.onNext(.success(data))
                            observer.onCompleted()
                        case 400:
                            print("в случае проблем с входными данными либо условиями для выполнения действия")
                            observer.onNext(.failure(.connectionError(ErrorString.unknownError.rawValue)))
                            observer.onCompleted()
                        case 404:
                            print("ресурс не найден")
                            observer.onNext(.failure(.authorizationError(ErrorString.unknownError.rawValue)))
                            observer.onCompleted()
                        default:
                            observer.onNext(.failure(.authorizationError(ErrorString.unknownError.rawValue)))
                            observer.onCompleted()
                        }
                    } else {
                        observer.onNext(.failure(.unknownError(ErrorString.unknownError.rawValue)))
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    observer.onNext(.failure(.serverError(error.localizedDescription)))
                    observer.onCompleted()
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
