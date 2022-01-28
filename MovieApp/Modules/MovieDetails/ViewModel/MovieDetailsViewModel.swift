//
//  MovieDetailsViewModel.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 08.10.2021..
//

import Foundation
import Combine

struct OutputDetails {
    var screenData: [MovieDetails]
    var outputActions: [MovieListOutput]
    let outputSubject: PassthroughSubject<[MovieListOutput], Never>
}

class MovieDetailsViewModel {
    
    var input = CurrentValueSubject<MovieListInput, Never>(.loading(showLoader: true))
    var output : OutputDetails
    
    var movie: MovieItem
    let persistence = Database()
    let repository = Repository()
    var genres : String
    var quote : String
    
    init(movie: MovieItem) {
        self.movie = movie
        self.genres = ""
        self.quote = ""
        output = OutputDetails(screenData: [],
                               outputActions: [],
                               outputSubject: PassthroughSubject<[MovieListOutput], Never>())
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
    
    func createScreenData(from response: MovieDetails) -> MovieDetails {
        for genre in response.genres {
            self.genres.append(genre.name + ", ")
        }
        self.genres = String(self.genres.dropLast())
        self.genres = String(self.genres.dropLast())
        self.quote = "\"" + response.tagline + "\""
        
        return response
    }
}
