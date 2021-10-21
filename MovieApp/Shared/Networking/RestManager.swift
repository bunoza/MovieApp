//
//  RestManager.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 21.10.2021..
//

import Foundation
import Alamofire

public class RestManager {
    private static let manager: Alamofire.Session = {
        var configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        let sessionManager = Session(configuration: configuration)
        return sessionManager
    }()
    
    public static func fetch<T: Codable>(url: String, completionHandler: @escaping (Result<T, NetworkError>) -> () ) {
        let request = RestManager.manager
            .request(url, encoding: URLEncoding.default)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    if let decodedObject: T = SerializationManager.parseData(jsonData: data) {
                        completionHandler(.success(decodedObject))
                    } else {
                        completionHandler(.failure(.parseFailed))
                    }
                case .failure(_):
                    completionHandler(.failure(.generalError))
                }
            }
        request.resume()
    }
}
