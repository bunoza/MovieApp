//
//  Database.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 18.12.2021..
//

import Foundation

class Database {
    
    let defaults = UserDefaults.standard
    
    func fetchAll() -> [MovieItem] {
        
        var unarchivedMovies : [MovieItem] = []

        do {
            let decodedMovies = defaults.object(forKey: "movies") as? Data
            unarchivedMovies = try NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClass: MovieItem.self, from: decodedMovies ?? Data())!
        }
        catch {}
        return unarchivedMovies
    }
    
    func fetchWatched() -> [MovieItem] {
        return fetchAll().filter({ $0.isWatched == true })
    }
    
    func fetchFavorites() -> [MovieItem] {
        return fetchAll().filter({ $0.isFavourite == true })
    }
    
    func store(movie : MovieItem) {
        var unarchivedMovies = fetchAll()
        
        unarchivedMovies.append(movie)
        do {
        let encoded = try NSKeyedArchiver.archivedData(withRootObject: unarchivedMovies, requiringSecureCoding: false)
            defaults.set(encoded, forKey: "movies")
        }
        catch{}
    }
    
    func storeAll(movies : [MovieItem]) {
        for movie in movies {
            store(movie: movie)
        }
    }
    
    func remove(movie : MovieItem) {
        storeAll(movies: fetchAll().filter({ $0.id != movie.id }))
    }
}