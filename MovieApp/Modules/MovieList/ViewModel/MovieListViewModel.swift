//
//  MovieListViewModel.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 04.10.2021..
//

import Foundation

class MovieListViewModel {
    
    var movies: [MovieItem] = []
    let repository : Repository
    let defaults = UserDefaults.standard
    
    init(){
        //        dependency injection
        repository = Repository()
    }
    
    var isLoading: ((Bool) -> ())?
    var dataReady: (() -> ())?
    var gotError: ((NetworkError) -> ())?
    
    func watchedToggle(value : MovieItem){
        var watched = defaults.object(forKey: "watched") as? [Int] ?? [Int]()
        if watched.contains(value.id) {
            watched = watched.filter {$0 != value.id}
            defaults.set(watched, forKey: "watched")
            print("Watched:  \(watched)")
        } else {
            watched.append(value.id)
            defaults.set(watched, forKey: "watched")
            print("Watched:  \(watched)")
        }
    }
    
    func favouriteToggle(value : MovieItem){
        var favourite = defaults.object(forKey: "favorites") as? [Int] ?? [Int]()
        if favourite.contains(value.id) {
            favourite = favourite.filter {$0 != value.id}
            defaults.set(favourite, forKey: "favorites")
            print("Favorites:  \(favourite)")
        } else {
            favourite.append(value.id)
            defaults.set(favourite, forKey: "favorites")
            print("Favorites:  \(favourite)")
        }
    }
    
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
                
                let watched = strongSelf.defaults.object(forKey: "watched") as? [Int] ?? [Int]()
                let favorites = strongSelf.defaults.object(forKey: "favorites") as? [Int] ?? [Int]()
                
                let movieItems = moviesResponse.map { movie -> MovieItem in
                    return MovieItem(id: movie.id,
                                     title: movie.title,
                                     overview: movie.overview,
                                     posterPath: movie.posterPath,
                                     releaseDate: movie.releaseDate,
                                     isFavourite: favorites.contains(movie.id) ? true : false,
                                     isWatched: watched.contains(movie.id) ? true : false)
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
