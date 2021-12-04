//
//  RestManager.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 21.10.2021..
//

import Foundation
import Alamofire
import Combine

public class RestManager {
    private static let manager: Alamofire.Session = {
        var configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        let sessionManager = Session(configuration: configuration)
        return sessionManager
    }()
    
    public static func fetch <T: Codable>(url: String) -> AnyPublisher<Result<T, NetworkError>, Never> {
        return Future { promise in
            guard let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                return promise(.success(.failure(.invalidUrl)))
            }
            let request = RestManager.manager
                .request(encodedUrl, encoding: URLEncoding.default)
                .validate()
                .responseData { (response) in
                    switch response.result {
                    case .success(let value):
                        if let decodedObject: T = SerializationManager.parseData(jsonData: value) {
                            promise(.success(.success(decodedObject)))
                        } else {
                            promise(.success(.failure(.parseFailed)))
                        }
                    case .failure(let error):
                        if let urlError = error.underlyingError as? URLError {
                            switch urlError.code {
                            case .timedOut, .notConnectedToInternet, .networkConnectionLost:
                                promise(.success(.failure(.notConnectedToInternet)))
                            default:
                                promise(.success(.failure(.generalError)))
                            }
                        } else {
                            promise(.success(.failure(.generalError)))
                        }
                        
                    }
                }
            request.resume()
        }.eraseToAnyPublisher()
    }
}
