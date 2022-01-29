//
//  MovieItem.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 21.10.2021..
//

import Foundation
import Combine

class MovieItem : Codable {
    
    var id: Int = 0
    var title: String = ""
    var overview: String = ""
    var posterPath: String = ""
    var releaseDate: String
    var isFavourite: Bool
    var isWatched: Bool
    
    init(id: Int, title: String, overview: String, posterPath: String, releaseDate: String, isFavourite: Bool, isWatched: Bool) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.isWatched = isWatched
        self.isFavourite = isFavourite
    }
}


