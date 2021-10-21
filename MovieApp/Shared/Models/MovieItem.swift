//
//  MovieItem.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 21.10.2021..
//

import Foundation

struct MovieItem {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String
    let releaseDate: String
    var isFavourite: Bool
    var isWatched: Bool
}
