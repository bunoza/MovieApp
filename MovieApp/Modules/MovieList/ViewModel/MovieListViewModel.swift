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
    case dataReadySimilar
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
    
    var currentRandomID: Int
    var currentRandomMovie: MovieItem
    
    var coordinatorDelegate: MovieListCoordinatorDelegate?
    
    init(){
        repository = Repository()
        output = Output(screenData: [],
                        outputActions: [],
                        outputSubject: PassthroughSubject<[MovieListOutput], Never>())
        currentRandomID = 0
        currentRandomMovie = MovieItem(id: 0, title: "", overview: "", posterPath: "", releaseDate: "", isFavourite: false, isWatched: false)
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
    
    func getRandomMovie() {
        repository.getLatestMovieID(completion: { id in
            self.currentRandomID = id
            let randomID = Int.random(in: 1...self.currentRandomID)
            self.repository.getMovieDetailsOnce(movieID: randomID) { movie in
                if movie.id == 0 {
                    self.getRandomMovie()
                } else if movie.adult == true {
                    self.getRandomMovie()
                }
                else {
                    self.currentRandomMovie = self.convertMovieDetailsToMovieItem(movie: movie)
                }
            }
        })
    }
    
    func convertMovieDetailsToMovieItem(movie: MovieDetails) -> MovieItem {
        let favoriteIds = persistance.fetchFavoritesIds()
        let watchedIds = persistance.fetchWatchedIds()

        return MovieItem(id: movie.id, title: movie.title, overview: movie.overview, posterPath: movie.poster_path, releaseDate: movie.release_date, isFavourite: favoriteIds.contains(movie.id) ? true : false, isWatched: watchedIds.contains(movie.id) ? true : false)
    }
    
    func setupBindings() -> AnyCancellable {
        return input
            .flatMap { [unowned self] inputAction -> AnyPublisher<[MovieListOutput], Never> in
                switch inputAction {
                case .loading:
                    return self.handleLoadScreenData(true)
                case .loaded:
                    return self.handleLoadScreenData(false)
                case .error:
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
                    self.output.outputSubject.send([.dataReady])
                case .failure(let error):
                    outputActions.append(.gotError(error.localizedDescription))
                }
                
                return Just(outputActions).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func createScreenData(from response: [Movie]) -> [MovieItem] {
        
        var temp = [MovieItem]()
        if response.isEmpty {
            return temp
        }
        
        let favoriteIds = persistance.fetchFavoritesIds()
        let watchedIds = persistance.fetchWatchedIds()
        print("favorites: \(favoriteIds)")
        print("watched: \(watchedIds)")
        
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
    
    func openDetails(with movie: MovieItem) {
        coordinatorDelegate?.openDetails(with: movie)
    }
}
