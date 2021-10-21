//
//  MovieListViewModel.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 04.10.2021..
//

import Foundation
import Combine

class MovieListViewModel {
    
    var movies: [MovieItem] = []
    let repository : Repository
    
    init(){
        //        dependency injection
        repository = Repository()
    }
    
    var isLoading: ((Bool) -> ())?
    var dataReady: (() -> ())?
    var gotError: ((NetworkError) -> ())?
    
    func ready() {
        ///begin loading
        isLoading?(true)
        
        repository.getMoviesList { [weak self] result in
            guard let strongSelf = self else { return }
            
            ///stop loading
            strongSelf.isLoading?(false)
            
            switch result {
            case .success(let movies):
                ///success loading data, notify VC
                let moviesResponse = movies.results
                let movieItems = moviesResponse.map { movie -> MovieItem in
                    return MovieItem(id: movie.id,
                                     title: movie.title,
                                     overview: movie.overview,
                                     posterPath: movie.posterPath,
                                     releaseDate: movie.releaseDate,
                                     isFavourite: false,
                                     isWatched: false)
                }
                strongSelf.movies = movieItems
                strongSelf.dataReady?()
            case .failure(let error):
                ///got error
                strongSelf.gotError?(error)
            }
        }
    }
}
