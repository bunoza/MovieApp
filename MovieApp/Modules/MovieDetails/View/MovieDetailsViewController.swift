//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 08.10.2021..
//

import UIKit

class MovieDetailsViewController : UIViewController {
    
    let viewModel : MovieDetailsViewModel
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let imageview : UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    let watchedButton : WatchedButton = {
        let watchedButton = WatchedButton()
        return watchedButton
    }()
    
    let favoriteButton : FavoriteButton = {
        let favoriteButton = FavoriteButton()
        return favoriteButton
    }()
    
    let movieDetailsStackView: MovieDetailsStackView = {
        let movieDetailsStackView = MovieDetailsStackView()
        movieDetailsStackView.translatesAutoresizingMaskIntoConstraints = false
        return movieDetailsStackView
    }()
    
    let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    init(viewModel : MovieDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    func setupCurrentMovie() {
        imageview.setImageFromUrl(url: Constants.imageBaseUrl + Constants.defaultPictureSize + viewModel.movie.posterPath)
        movieDetailsStackView.setTitleText(title: viewModel.movie.title)
        movieDetailsStackView.setGenreText(text: viewModel.movie.releaseDate)
        movieDetailsStackView.setContentText(text: viewModel.movie.overview)
        watchedButton.button.addTarget(self, action: #selector(toggleWatched), for: .touchUpInside)
        favoriteButton.button.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        viewModel.movie.isWatched ? watchedButton.turnOn() : watchedButton.turnOff()
        viewModel.movie.isFavourite ? favoriteButton.turnOn() : favoriteButton.turnOff()
    }
    
    @objc func toggleWatched() {
        if self.viewModel.movie.isWatched {
            watchedButton.turnOff()
        } else {
            watchedButton.turnOn()
        }
        viewModel.watchedToggle()
    }
    
    @objc func toggleFavorite() {
        if self.viewModel.movie.isFavourite {
            favoriteButton.turnOff()
        } else {
            favoriteButton.turnOn()
        }
        viewModel.favouriteToggle()
    }
    
    func setupViewModel() {
        viewModel.dataReady = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.setupCurrentMovie()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setupViewModel()
        view.backgroundColor = .darkGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        //        navigationController?.navigationBar.barTintColor = .systemGray6
        //        navigationController?.hidesBarsOnSwipe = true
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: watchedButton), UIBarButtonItem(customView: favoriteButton)]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        setupViews()
        setupConstraints()
        configureNavigationBar(title: viewModel.movie.title)
        viewModel.ready()
    }
    
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(imageview)
        contentView.addSubview(movieDetailsStackView)
        
        contentView.insertSubview(watchedButton, aboveSubview: imageview)
        contentView.insertSubview(favoriteButton, aboveSubview: imageview)
    }
    
    func configureNavigationBar(title : String) {
        //        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, .font : UIFont.init(name: "Avenir Next Condensed Bold", size: 20)!]
        //        self.navigationItem.title = title
        //        let appearance = UINavigationBarAppearance()
        //        appearance.configureWithTransparentBackground()
        //        appearance.backgroundColor = .systemGray6
        ////         promjeni boju
        //        self.navigationController?.navigationBar.standardAppearance = appearance;
        //        self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
        
    }
    
    func setupConstraints(){
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.bottom.equalTo(view)
            make.width.equalTo(view)
            make.height.equalTo(view)
        }
        imageview.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(550)
            make.width.equalToSuperview()
        }
        movieDetailsStackView.snp.makeConstraints { make in
            make.top.equalTo(imageview.snp.bottom)
            make.width.equalToSuperview()
        }
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView)
            make.bottom.equalTo(scrollView)
            make.width.equalTo(scrollView)
            make.height.equalTo(scrollView)
        }
    }
}
