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
    
    func fetchWatchedIds() -> [Int] {
        return fetchWatched().map({ return $0.id })
    }
    
    func fetchFavoritesIds() -> [Int] {
        return fetchFavorites().map({ return $0.id })
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
        do {
        let encoded = try NSKeyedArchiver.archivedData(withRootObject: movies, requiringSecureCoding: false)
            defaults.set(encoded, forKey: "movies")
        }
        catch{}
    }
    
    func remove(movie : MovieItem) {
        storeAll(movies: fetchAll().filter({ $0.id != movie.id }))
    }
    
    func removeByID(id : Int) {
        storeAll(movies: fetchAll().filter({ $0.id != id }))
    }
    
}
