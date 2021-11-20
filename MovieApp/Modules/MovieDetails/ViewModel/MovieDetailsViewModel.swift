//
//  MovieDetailsViewModel.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 08.10.2021..
//

import Foundation

class MovieDetailsViewModel {
    
    var movie: MovieItem
    var movieDetails : [MovieDetails] = []
    let defaults = UserDefaults.standard
    let repository = Repository()
    var genres : String
    var quote : String
    
    var isLoading: ((Bool) -> ())?
    var dataReady: (() -> ())?
    var gotError: ((NetworkError) -> ())?
    
    init(movie: MovieItem) {
        self.movie = movie
        self.genres = ""
        self.quote = ""
    }
    
    func watchedToggle(){
        var watched = defaults.object(forKey: "watched") as? [Int] ?? [Int]()
        if watched.contains(movie.id) {
            watched = watched.filter {$0 != movie.id}
            defaults.set(watched, forKey: "watched")
            movie.isWatched = false
            print("Watched:  \(watched)")
        } else {
            watched.append(movie.id)
            defaults.set(watched, forKey: "watched")
            movie.isWatched = true
            print("Watched:  \(watched)")
        }
    }
    
    func favouriteToggle(){
        var favourite = defaults.object(forKey: "favorites") as? [Int] ?? [Int]()
        if favourite.contains(movie.id) {
            favourite = favourite.filter {$0 != movie.id}
            defaults.set(favourite, forKey: "favorites")
            movie.isWatched = false
            print("Favorites:  \(favourite)")
        } else {
            favourite.append(movie.id)
            defaults.set(favourite, forKey: "favorites")
            movie.isWatched = true
            print("Favorites:  \(favourite)")
        }
    }
    
    func ready() {
        ///begin loading
        isLoading?(true)
        
        repository.getMovieDetails(movieID: movie.id) { [weak self] result in
            guard let strongSelf = self else { return }
            
            ///stop loading
            strongSelf.isLoading?(false)
            
            switch result {
            case .success(let movies):
                ///success loading data, notify VC
                strongSelf.movieDetails.append(movies)
                
                for genre in movies.genres {
                    strongSelf.genres.append(genre.name + ", ")
                }
                strongSelf.genres = String(strongSelf.genres.dropLast())
                strongSelf.genres = String(strongSelf.genres.dropLast())
                strongSelf.quote = "\"" + movies.tagline + "\""
                strongSelf.dataReady?()
            case .failure(let error):
                ///got error
                strongSelf.gotError?(error)
            }
        }
    }
}
