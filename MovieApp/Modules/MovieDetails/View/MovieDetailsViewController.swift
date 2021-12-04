//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 08.10.2021..
//

import UIKit
import Combine

class MovieDetailsViewController : UIViewController {
    
    let viewModel : MovieDetailsViewModel
    
    var observers = Set<AnyCancellable>()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInset = UIEdgeInsets(top: -95, left: 0, bottom: 0, right: 0)
        return scrollView
    }()
    
    let imageGradient : ImageGradient = {
        let imageGradient = ImageGradient()
        imageGradient.translatesAutoresizingMaskIntoConstraints = false
        return imageGradient
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
        imageGradient.configureImageGradient(imageURL: Constants.imageBaseUrl + Constants.defaultPictureSize + viewModel.movie.posterPath)
        movieDetailsStackView.setTitleText(title: viewModel.movie.title)
        movieDetailsStackView.setGenreText(text: viewModel.genres)
        movieDetailsStackView.setDescriptionText(text: viewModel.quote)
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
    
    func setupBindings() {
        viewModel.setupBindings().store(in: &observers)
        
        viewModel.output.outputSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [weak self] outputActions in
                for action in outputActions {
                    self?.handle(action)
                    print("Action: \(action)")
                }
            }
            .store(in: &observers)
    }
    
    func handle(_ action: MovieListOutput) {
        switch action {
        case .dataReady:
            self.setupCurrentMovie()
            print("setup current movie")
        case .showLoader(let showLoader):
            if showLoader {
                showOverlay(on: self)
            } else {
                dismissOverlay(on: self)
            }
        case.gotError(let message):
            showErrorAlert(on: self)
            print(message)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setupBindings()
        
        view.backgroundColor = UIColor(red: 0.17, green: 0.17, blue: 0.18, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = true
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: watchedButton), UIBarButtonItem(customView: UIButton()), UIBarButtonItem(customView: favoriteButton)]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(imageGradient)
        contentView.addSubview(movieDetailsStackView)
        contentView.insertSubview(watchedButton, aboveSubview: imageGradient)
        contentView.insertSubview(favoriteButton, aboveSubview: imageGradient)
    }
    
    func setupConstraints(){
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.bottom.equalTo(view)
            make.width.equalTo(view)
        }
        imageGradient.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(550)
            make.width.equalToSuperview()
            make.top.equalTo(contentView)
        }
        movieDetailsStackView.snp.makeConstraints { make in
            make.top.equalTo(imageGradient.snp.bottom)
            make.bottom.equalTo(contentView.snp.bottom)
            make.width.equalToSuperview()
        }
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView)
            make.bottom.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
    }
    
    
    
}
