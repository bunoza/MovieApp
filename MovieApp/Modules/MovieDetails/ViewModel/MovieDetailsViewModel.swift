////
////  MovieDetailsViewModel.swift
////  MovieApp
////
////  Created by Domagoj Bunoza on 08.10.2021..
////
//
//import Foundation
//
//class MovieDetailsViewModel {
//
//    let id : Int
//
//    let repository : Repository
//
//    var posterPath : String
//    var movieTitle : String
//    var movieGenres : Genre
//    var tagline : String
//    var overview : String
//
//    init(id : Int){
//        //        dependency injection
//        self.id = id
//        repository = Repository()
//
//        posterPath = ("")
//        movieTitle = ("")
////        movieGenres = Genre()
//        tagline = ("")
//        overview = ("")
//        setupBindings()
//        repository.getMovieDetails(with: id)
//    }
//
//    func setupBindings(){
////        repository.movieDetails.bind { _ in
////            self.posterPath.value = self.repository.movieDetails.value.poster_path
////            self.movieTitle.value = self.repository.movieDetails.value.title
////            self.movieGenres.value = self.repository.movieDetails.value.genres
////            self.tagline.value = self.repository.movieDetails.value.tagline
////            self.overview.value = self.repository.movieDetails.value.overview
////        }
////        repository.status.bind { _ in
////            self.status = self.repository.status
////        }
//    }
//    func getMovieDetails(){
//        repository.getMovieDetails(with: id)
//    }
//
//    func getStatus() -> Status {
//        return status
//    }
//
//}
