//
//  MovieDetails.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 20.11.2021..
//

import Foundation

public struct MovieDetails : Codable {
    var backdrop_path: String?
    var genres: [Genre]
    var id: Int
    var imdb_id, original_language, original_title, overview: String
    var poster_path: String
    var release_date: String
    var status, tagline, title: String
    
    enum CodingKeys: String, CodingKey {
        case backdrop_path
        case genres
        case id
        case imdb_id
        case original_language
        case original_title
        case overview
        case poster_path
        case release_date
        case status
        case tagline
        case title
    }
}

// MARK: - Genre
struct Genre : Codable {
    var id: Int
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
