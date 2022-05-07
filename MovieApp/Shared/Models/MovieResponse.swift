//
//  Root.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 04.12.2021..
//

import Foundation

struct MovieResponse : Codable{
    let page: Int
    let results: [Movie]
    let total_pages, total_results: Int
}
