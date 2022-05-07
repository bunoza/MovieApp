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
    
    public static func fetchLatestID(url: String, completion: @escaping (Int) -> ()) {
        AF.request(url)
            .validate()
            .responseDecodable(of: LatestMovieID.self) { (response) in
                guard let film = response.value else { return }
                completion(film.id)
            }
    }
    
    public static func fetchMovieDetailsOnce(url: String, completion: @escaping (MovieDetails) -> ()) {
        AF.request(url)
            .validate()
            .responseDecodable(of: MovieDetails.self) { (response) in
                guard let film = response.value else {
                    completion(
                    MovieDetails(genres: [], id: 0, imdb_id: "", original_language: "", original_title: "", overview: "", poster_path: "", release_date: "", status: "", tagline: "", title: "")
                    )
                    return
                }
                completion(film)
            }
    }
}
