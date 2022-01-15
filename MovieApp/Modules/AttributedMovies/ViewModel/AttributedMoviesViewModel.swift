//
//  FavoriteMoviesViewModel.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 04.12.2021..
//

import Foundation
import Combine

class AttributedMoviesViewModel {
    
    var input = CurrentValueSubject<MovieListInput, Never>(.loading(showLoader: true))
    
    let repository : Repository
    let defaults = UserDefaults.standard
    let persistance = Database()
    var output : Output
    
    let tag : String
    
    init(tag : String){
        repository = Repository()
        output = Output(screenData: [],
                        outputActions: [],
                        outputSubject: PassthroughSubject<[MovieListOutput], Never>())
        self.tag = tag
    }
    
    func watchedToggle(index : Int) {
        output.screenData[index].isWatched.toggle()
        persistance.remove(movie: output.screenData[index])
        if output.screenData[index].isFavourite || output.screenData[index].isWatched {
            persistance.store(movie: output.screenData[index])
        }
        output.outputSubject.send([.dataReady])
    }
    
    func favouriteToggle(index : Int) {
        output.screenData[index].isFavourite.toggle()
        persistance.remove(movie: output.screenData[index])
        if output.screenData[index].isFavourite || output.screenData[index].isWatched {
            persistance.store(movie: output.screenData[index])
        }
        output.outputSubject.send([.dataReady])
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
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
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
                    output.outputActions.append(.dataReady)
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

        let favoriteIds = persistance.fetchFavoritesIds()
        let watchedIds = persistance.fetchWatchedIds()
        
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
        if self.tag == "watched" {
            temp = temp.filter({$0.isWatched != false})
        }
        if self.tag == "favorites" {
            temp = temp.filter({$0.isFavourite != false})
        }
        return temp
    }
}

