//
//  MovieDetailsViewModel.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 08.10.2021..
//

import Foundation

class MovieDetailsViewModel {

    var movie: MovieItem
    let defaults = UserDefaults.standard


    var dataReady: (() -> ())?
    
    
    init(movie: MovieItem) {
        self.movie = movie
    }
    
    func ready() {
        dataReady?()
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
}
