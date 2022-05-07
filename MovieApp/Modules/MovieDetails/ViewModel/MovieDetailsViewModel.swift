//
//  MovieDetailsViewModel.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 08.10.2021..
//

import Foundation
import Combine

struct OutputDetails {
    var screenDataDetails: [MovieDetails]
    var screenDataSimilar: [MovieItem]
    var outputActions: [MovieListOutput]
    let outputSubject: PassthroughSubject<[MovieListOutput], Never>
}

struct InputDetails {
    var inputDetails = CurrentValueSubject<MovieListInput, Never>(.loading(showLoader: true))
    var inputSimilar = CurrentValueSubject<MovieListInput, Never>(.loading(showLoader: true))
}

class MovieDetailsViewModel {
    
    var output : OutputDetails
    var input : InputDetails
    
    var movie: MovieItem
    let persistence = Database()
    let repository = Repository()
    var genres : String
    var quote : String
    var detailsRequested : Bool
    
    var coordinatorDelegate: MovieDetailsCoordinator?

    
    init(movie: MovieItem) {
        self.movie = movie
        self.genres = ""
        self.quote = ""
        output = OutputDetails(screenDataDetails: [],
                               screenDataSimilar: [],
                               outputActions: [],
                               outputSubject: PassthroughSubject<[MovieListOutput], Never>())
        input = InputDetails()
        detailsRequested = false
    }
    
    func watchedToggle() {
        movie.isWatched.toggle()
        persistence.removeByID(id: movie.id)
        if movie.isFavourite || movie.isWatched {
            persistence.store(movie: movie)
        }
        output.outputSubject.send([.dataReady])
    }
    
    func favouriteToggle() {
        movie.isFavourite.toggle()
        persistence.removeByID(id: movie.id)
        if movie.isFavourite || movie.isWatched {
            persistence.store(movie: movie)
        }
        output.outputSubject.send([.dataReady])
    }
    
    func setupBindings() -> (AnyCancellable, AnyCancellable) {
        return (input.inputDetails
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
                ,
                input.inputSimilar
                    .flatMap { [unowned self] inputAction -> AnyPublisher<[MovieListOutput], Never> in
                        switch inputAction {
                        case .loading:
                            print("show loader")
                            return self.handleLoadScreenDataSimilar(true)
                        case .loaded:
                            print("dismiss loader")
                            return self.handleLoadScreenDataSimilar(false)
                        case .error:
                            print("error")
                            return self.handleLoadScreenDataSimilar(false)
                        }
                    }
                    .subscribe(on: DispatchQueue.global(qos: .background))
                    .receive(on: RunLoop.main)
                    .sink { [unowned self] outputActions in
                        self.output.outputSubject.send(outputActions)
                    }
        )
    }
    
    func handleLoadScreenData(_ showLoader: Bool) -> AnyPublisher<[MovieListOutput], Never> {
        var outputActions = [MovieListOutput]()
        return repository.getMovieDetails(movieID: movie.id)
            .map({ [unowned self] responseResult -> Result<[MovieDetails], NetworkError> in
                //self.output.outputActions.append(.showLoader(showLoader))
                self.output.outputSubject.send([.showLoader(showLoader)])
                switch responseResult {
                case .success(let response):
                    let screenData = self.createScreenData(from: response)
                    return .success([screenData])
                case .failure(let error):
                    return .failure(error)
                }
            })
            .flatMap { [unowned self] responseResult -> AnyPublisher<[MovieListOutput], Never> in
                outputActions.append(.showLoader(false))
                self.output.outputSubject.send([.showLoader(false)])
                switch responseResult {
                case .success(let screenData):
                    self.output.screenDataDetails = screenData
                    output.outputActions.append(.dataReady)
                    self.output.outputSubject.send([.dataReady])
                    print(output.outputActions)
                case .failure(let error):
                    outputActions.append(.gotError(error.localizedDescription))
                }
                
                return Just(outputActions).eraseToAnyPublisher()
            }.eraseToAnyPublisher()
    }
    
    func handleLoadScreenDataSimilar(_ showLoader: Bool) -> AnyPublisher<[MovieListOutput], Never> {
        var outputActions = [MovieListOutput]()
        return repository.getSimilarMovies(movieID: movie.id)
            .map({ [unowned self] responseResult -> Result<[MovieItem], NetworkError> in
                //self.output.outputActions.append(.showLoader(showLoader))
                self.output.outputSubject.send([.showLoader(showLoader)])
                switch responseResult {
                case .success(let response):
                    let screenData = self.createScreenDataSimilar(from: response)
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
                    self.output.screenDataSimilar = screenData
                    output.outputActions.append(.dataReadySimilar)
                    self.output.outputSubject.send([.dataReadySimilar])
//                    print(output.outputActions)
                case .failure(let error):
                    outputActions.append(.gotError(error.localizedDescription))
                }
                
                return Just(outputActions).eraseToAnyPublisher()
            }.eraseToAnyPublisher()
    }
    
    func createScreenData(from response: MovieDetails) -> MovieDetails {
        for genre in response.genres {
            self.genres.append(genre.name + ", ")
        }
        self.genres = String(self.genres.dropLast())
        self.genres = String(self.genres.dropLast())
        self.quote = "\"" + response.tagline + "\""
        
        return response
    }
    
    func createScreenDataSimilar(from response: MovieResponse) -> [MovieItem] {
        var temp = [MovieItem]()

        let favoriteIds = persistence.fetchFavoritesIds()
        let watchedIds = persistence.fetchWatchedIds()
        
        let moviesResult = response.results

        temp = moviesResult.map({
            movie in
            return MovieItem(id: movie.id,
                             title: movie.title,
                             overview: movie.overview,
                             posterPath: movie.posterPath,
                             releaseDate: movie.releaseDate,
                             isFavourite: favoriteIds.contains(movie.id) ? true : false,
                             isWatched: watchedIds.contains(movie.id) ? true : false)
        })
        
        print(temp.map{$0.title})
        return temp
    }
    
    func didFinish() {
        coordinatorDelegate?.coordinatorDidFinish()
    }
}
