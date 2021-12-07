//
//  WatchedMoviesViewModel.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 04.12.2021..
//

import Foundation
import Combine

class WatchedMoviesViewModel {
    
    var input = CurrentValueSubject<MovieListInput, Never>(.loading(showLoader: true))
    
    let repository : Repository
    let defaults = UserDefaults.standard
    var output : Output
    
    init(){
        repository = Repository()
        output = Output(screenData: [],
                        outputActions: [],
                        outputSubject: PassthroughSubject<[MovieListOutput], Never>())
    }
    
    func watchedToggle(value : MovieItem){
        var watched = [MovieItem]()
                
        do {
            //get
            guard let decoded  = defaults.object(forKey: "watched") as? Data
            else {
                watched.append(value)
                let encoded = try NSKeyedArchiver.archivedData(withRootObject: watched, requiringSecureCoding: false)
                defaults.set(encoded, forKey: "watched")
                return
            }
            var decodedWatched = try NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClass: MovieItem.self, from: decoded)
            var decodedIds = [Int]()
            
            for movieID in decodedWatched! {
                decodedIds.append(movieID.id)
            }
            if decodedIds.contains(value.id) {
                decodedWatched = decodedWatched?.filter({$0.id != value.id})
                decodedIds = decodedIds.filter({$0 != value.id})
            }
            else {
                decodedWatched?.append(value)
                decodedIds.append(value.id)
            }
            print("Watched ids: \(decodedIds)")
            
            let encoded = try NSKeyedArchiver.archivedData(withRootObject: decodedWatched!, requiringSecureCoding: false)
            defaults.set(encoded, forKey: "watched")

        }
        catch {
            print(error)
        }
    }
    
    func favouriteToggle(value : MovieItem){
        var favourites = [MovieItem]()
                
        do {
            //get
            guard let decoded  = defaults.object(forKey: "favorites") as? Data
            else {
                favourites.append(value)
                let encoded = try NSKeyedArchiver.archivedData(withRootObject: favourites, requiringSecureCoding: false)
                defaults.set(encoded, forKey: "favorites")
                return
            }
            var decodedFavorites = try NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClass: MovieItem.self, from: decoded)
            var decodedIds = [Int]()
            
            for movieID in decodedFavorites! {
                decodedIds.append(movieID.id)
            }
            if decodedIds.contains(value.id) {
                decodedFavorites = decodedFavorites?.filter({$0.id != value.id})
                decodedIds = decodedIds.filter({$0 != value.id})
            }
            else {
                decodedFavorites?.append(value)
                decodedIds.append(value.id)
            }
            print("Favorites ids: \(decodedIds)")
            
            let encoded = try NSKeyedArchiver.archivedData(withRootObject: decodedFavorites!, requiringSecureCoding: false)
            defaults.set(encoded, forKey: "favorites")

        }
        catch {
            print(error)
        }

    }
    
    func setupBindings() -> AnyCancellable {
        return input
            .flatMap { [unowned self] inputAction -> AnyPublisher<[MovieListOutput], Never> in
                switch inputAction {
                case .loading:
                    print("show loader")
                    return self.handleLoadScreenData(true)
                case .loaded:
                    print("dismiss loader")
                    return self.handleLoadScreenData(false)
                case .error:
                    print("error")
                    return self.handleLoadScreenData(false)
                }
            }
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] outputActions in
                self.output.outputSubject.send(outputActions)
            }
    }
    
    func handleLoadScreenData(_ showLoader: Bool) -> AnyPublisher<[MovieListOutput], Never> {
        let outputActions = [MovieListOutput]()
        output.screenData = createScreenData()
        self.output.outputSubject.send([.dataReady])

        return Just(outputActions).eraseToAnyPublisher()
    }

    
    
    func createScreenData() -> [MovieItem] {
        var temp = [MovieItem]()

        var unarchivedFavorites : [MovieItem] = []
        var unarchivedWatched : [MovieItem] = []

        do {
            let decodedFavorites  = defaults.object(forKey: "favorites") as? Data
            let decodedWatched  = defaults.object(forKey: "watched") as? Data
            unarchivedFavorites = try NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClass: MovieItem.self, from: decodedFavorites ?? Data())!
            unarchivedWatched = try NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClass: MovieItem.self, from: decodedWatched ?? Data())!
        }
        catch {
        }

        var favoriteIds = [Int]()
        var watchedIds = [Int]()

        for movieID in unarchivedFavorites {
            favoriteIds.append(movieID.id)
        }

        for movieID in unarchivedWatched {
            watchedIds.append(movieID.id)
        }
        
        temp = unarchivedWatched.map({
            movie in
            return MovieItem(id: movie.id,
                             title: movie.title,
                             overview: movie.overview,
                             posterPath: movie.posterPath,
                             releaseDate: movie.releaseDate,
                             isFavourite: favoriteIds.contains(movie.id) ? true : false,
                             isWatched: watchedIds.contains(movie.id) ? true : false)
        })
        temp = temp.filter({$0.isWatched != false})
        return temp
    }
}

