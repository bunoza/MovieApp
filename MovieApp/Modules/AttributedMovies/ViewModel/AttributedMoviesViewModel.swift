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
    
    var coordinatorDelegate: AttributedCoordinatorDelegate?
    
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
        output.screenData.remove(at: index)
               
        output.outputSubject.send([.dataReady])
    }
    
    func favouriteToggle(index : Int) {
        output.screenData[index].isFavourite.toggle()
        persistance.remove(movie: output.screenData[index])
        if output.screenData[index].isFavourite || output.screenData[index].isWatched {
            persistance.store(movie: output.screenData[index])
        }
        output.screenData.remove(at: index)
        output.outputSubject.send([.dataReady])
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
        self.output.screenData = createScreenData()
        output.outputActions.append(.dataReady)
        self.output.outputSubject.send([.dataReady])
        return Just(outputActions).eraseToAnyPublisher()
    }
    
    func createScreenData() -> [MovieItem] {
        var temp = [MovieItem]()
        
        if tag == "watched" {
            temp = persistance.fetchWatched()
        } else if tag == "favorites" {
            temp = persistance.fetchFavorites()
        }
        return temp
    }
    
    func openDetails(with movie: MovieItem) {
        coordinatorDelegate?.openDetails(with: movie)
    }
}

