//
//  MovieListViewModel.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 04.10.2021..
//

import Foundation
import Combine

enum MovieListOutput {
    case showLoader(Bool)
    case dataReady
    case gotError(String)
}

struct Output {
    var screenData: [MovieItem]
    var outputActions: [MovieListOutput]
    let outputSubject: PassthroughSubject<[MovieListOutput], Never>
}

class MovieListViewModel {
    
    var input = CurrentValueSubject<MovieListInput, Never>(.loading(showLoader: true))
    
    let repository : Repository
    let defaults = UserDefaults.standard
    let persistance = Database()
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
        var outputActions = [MovieListOutput]()
        return repository.getMoviesList()
            .map({ [unowned self] responseResult -> Result<[MovieItem], NetworkError> in
                //self.output.outputActions.append(.showLoader(showLoader))
                self.output.outputSubject.send([.showLoader(showLoader)])
                switch responseResult {
                case .success(let response):
                    let screenData = self.createScreenData(from: response.results)
                    return .success(screenData)
                case .failure(let error):
                    return .failure(error)
                }
            })
            .flatMap { [unowned self] responseResult -> AnyPublisher<[MovieListOutput], Never> in
                outputActions.append(.showLoader(false))
                self.output.outputSubject.send([.showLoader(false)])
                switch responseResult {
                case .success(let screenData):
                    self.output.screenData = screenData
//                    output.outputActions.append(.dataReady)
                    self.output.outputSubject.send([.dataReady])
                    print(output.outputActions)
                case .failure(let error):
                    outputActions.append(.gotError(error.localizedDescription))
                }
                
                return Just(outputActions).eraseToAnyPublisher()
            }.eraseToAnyPublisher()
    }
    
    func createScreenData(from response: [Movie]) -> [MovieItem] {
        var temp = [MovieItem]()
        if response.isEmpty {
            return temp
        }
        
        

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

        temp = response.map({
            movie in
            return MovieItem(id: movie.id,
                             title: movie.title,
                             overview: movie.overview,
                             posterPath: movie.posterPath,
                             releaseDate: movie.releaseDate,
                             isFavourite: favoriteIds.contains(movie.id) ? true : false,
                             isWatched: watchedIds.contains(movie.id) ? true : false)
        })
        return temp
    }
}

