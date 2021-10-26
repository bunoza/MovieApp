//
//  MovieDetailsViewModel.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 08.10.2021..
//

import Foundation

class MovieDetailsViewModel {

    var movie: MovieItem

    var dataReady: (() -> ())?
    
    
    init(movie: MovieItem) {
        self.movie = movie
    }
    
    func ready() {
        dataReady?()
    }
}
