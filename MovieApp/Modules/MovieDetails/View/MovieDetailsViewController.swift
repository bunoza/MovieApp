////
////  MovieDetailsViewController.swift
////  MovieApp
////
////  Created by Domagoj Bunoza on 08.10.2021..
////
//
//import UIKit
//
//class MovieDetailsViewController : UIViewController {
//
//    let viewModel : MovieDetailsViewModel
//
//    let scrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        return scrollView
//    }()
//
//    let imageview : UIImageView = {
//        let imageview = UIImageView()
//        imageview.translatesAutoresizingMaskIntoConstraints = false
//        return imageview
//    }()
//
//    let movieDetailsStackView: MovieDetailsStackView = {
//        let movieDetailsStackView = MovieDetailsStackView()
//        movieDetailsStackView.translatesAutoresizingMaskIntoConstraints = false
//        return movieDetailsStackView
//    }()
//
//    init(viewModel : MovieDetailsViewModel) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    //    func setupCurrentMovie() {
//    //        imageview.setImageFromUrl(url: Constants.imageBaseUrl + Constants.defaultPictureSize + currentMovie.poster_path)
//    //        movieDetailsStackView.setTitleText(title: currentMovie.title)
//    //        movieDetailsStackView.setContentText(text: currentMovie.overview)
//    //    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func loadView() {
//        super.loadView()
//        view.backgroundColor = .white
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configureBackButton(title: "News reader")
//        setupViews()
//        setupConstraints()
//        setupBindings()
//        viewModel.getMovieDetails()
//    }
//
//    func setupBindings(){
////        viewModel.posterPath.bind { _ in
////            self.imageview.setImageFromUrl(url: Constants.imageBaseUrl + Constants.defaultPictureSize + self.viewModel.posterPath.value)
////        }
////        viewModel.movieTitle.bind { _ in
////            self.movieDetailsStackView.setTitleText(title: self.viewModel.movieTitle.value)
////        }
////        viewModel.overview.bind { _ in
////            self.movieDetailsStackView.setTitleText(title: self.viewModel.movieTitle.value)
////        }
//
//    }
//
//    func setupViews() {
//        view.addSubview(scrollView)
//        scrollView.addSubview(movieDetailsStackView)
//        scrollView.addSubview(imageview)
//    }
//
//    func configureTitle(title : String) {
//        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, .font : UIFont.init(name: "Avenir Next Condensed Bold", size: 20)!]
//        self.navigationController?.navigationBar.barTintColor = UIColor.blue
//        self.navigationItem.title = title
//    }
//
//    func configureBackButton(title : String) {
//        self.navigationItem.backBarButtonItem?.title = title
//    }
//
//    func setupConstraints(){
//        scrollView.snp.makeConstraints { make in
//            make.edges.equalTo(view.safeAreaLayoutGuide)
//        }
//        imageview.snp.makeConstraints { make in
//            make.height.equalTo(250)
//            make.width.equalToSuperview()
//        }
//        movieDetailsStackView.snp.makeConstraints { make in
//            make.top.equalTo(imageview.snp.bottom)
//            make.width.equalTo(view.safeAreaLayoutGuide)
//        }
//    }
//}
