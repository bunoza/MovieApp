//
//  Constants.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 07.10.2021..
//

import Foundation
import UIKit

struct Constants {
    static let apiKey = "a2c3633d3b882fa9fd3769aeb7499dea"
    static let baseUrl = "https://api.themoviedb.org/3/movie/"
    static let urlForData = "now_playing?language=en-US&page=1&api_key="
    static let defaultPictureSize = "w500"
    static let imageBaseUrl =  "https://image.tmdb.org/t/p/"
    static let movieDetailsApiKey =  "?api_key="
    static let similar = "/similar"
    static let latest = "/latest"
}

struct Color {
    static let cellContentViewBackgroundColor = UIColor(named: "CellContentViewBackgroundColor")
    static let cellViewBackgroundColor = UIColor(named: "CellViewBackgroundColor")
    static let highlightedCellColor = UIColor(named: "HighlightedCellColor")
    static let cellGradientStartColor = UIColor(named: "CellGradientStartColor")?.cgColor
    static let cellGradientEndColor = UIColor(named: "CellGradientEndColor")?.cgColor
    static let detailsGradientStartColor = UIColor(named: "DetailsGradientStartColor")?.cgColor
    static let detailsGradientEndColor = UIColor(named: "DetailsGradientEndColor")?.cgColor
}
