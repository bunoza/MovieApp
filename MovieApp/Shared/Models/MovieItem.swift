//
//  MovieItem.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 21.10.2021..
//

import Foundation
import Combine

class MovieItem : NSObject, NSCoding, NSSecureCoding {
    static var supportsSecureCoding: Bool  = true
    
    
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
    
    
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(title, forKey: "title")
        coder.encode(overview, forKey: "overview")
        coder.encode(posterPath, forKey: "posterPath")
        coder.encode(releaseDate, forKey: "releaseDate")
        coder.encode(isWatched, forKey: "isWatched")
        coder.encode(isFavourite, forKey: "isFavourite")
    }
    
    required convenience init?(coder: NSCoder) {
        let id = coder.decodeInteger(forKey: "id")
        let title = coder.decodeObject(forKey: "title") as! String
        let overview = coder.decodeObject(forKey: "overview") as! String
        let posterPath = coder.decodeObject(forKey: "posterPath") as! String
        let releaseDate = coder.decodeObject(forKey: "releaseDate") as! String
        let isWatched = coder.decodeBool(forKey: "isWatched")
        let isFavourite = coder.decodeBool(forKey: "isFavourite")
        self.init(id: id, title: title, overview: overview, posterPath: posterPath, releaseDate: releaseDate, isFavourite: isFavourite, isWatched: isWatched)
    }
   
}


