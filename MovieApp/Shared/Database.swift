//
//  Database.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 18.12.2021..
//

import Foundation

class Database {
    
    let defaults = UserDefaults.standard
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
        
    func fetchAll() -> [MovieItem] {
        var unarchivedMovies : [MovieItem] = []
        do {
            guard let decodedMovies = defaults.data(forKey: "movies")
            else {
                return unarchivedMovies
            }
                unarchivedMovies = try decoder.decode([MovieItem].self, from: decodedMovies)
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
            let data = try encoder.encode(unarchivedMovies)
            defaults.set(data, forKey: "movies")
        }
        catch{}
    }
    
    func storeAll(movies : [MovieItem]) {
        do {
            let data = try encoder.encode(movies)
            defaults.set(data, forKey: "movies")
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
