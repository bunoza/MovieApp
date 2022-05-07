//
//  Repository.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 07.10.2021..
//

import Foundation
import Combine

class Repository {
    
    func getMoviesList() -> AnyPublisher<Result<MovieResponse, NetworkError>, Never> {
        RestManager.fetch(url: "https://api.themoviedb.org/3/movie/now_playing?api_key=aaf38b3909a4f117db3fb67e13ac6ef7&language=en-US&page=1")
    }
    
    func getMovieDetails(movieID : Int) -> AnyPublisher<Result<MovieDetails, NetworkError>, Never> {
        RestManager.fetch(url: Constants.baseUrl + String(movieID) + Constants.movieDetailsApiKey + Constants.apiKey)
    }
    
    func getSimilarMovies(movieID : Int) -> AnyPublisher<Result<MovieResponse, NetworkError>, Never> {
        RestManager.fetch(url: Constants.baseUrl + String(movieID) + Constants.similar + Constants.movieDetailsApiKey + Constants.apiKey)
    }
    
    func getLatestMovieID(completion: @escaping (Int) -> ()) {
        RestManager.fetchLatestID(url: Constants.baseUrl + Constants.latest + Constants.movieDetailsApiKey + Constants.apiKey, completion: completion)
    }
    func getMovieDetailsOnce(movieID : Int, completion: @escaping (MovieDetails) -> ()) {
        RestManager.fetchMovieDetailsOnce(url: Constants.baseUrl + String(movieID) + Constants.movieDetailsApiKey + Constants.apiKey, completion: completion)
    }
}
