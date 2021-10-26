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
    
    let movieDetailsStackView: MovieDetailsStackView = {
        let movieDetailsStackView = MovieDetailsStackView()
        movieDetailsStackView.translatesAutoresizingMaskIntoConstraints = false
        return movieDetailsStackView
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
//        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        configureNavigationBar(title: viewModel.movie.title)
        viewModel.ready()
    }
    
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(movieDetailsStackView)
        scrollView.addSubview(imageview)
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
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        imageview.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(550)
            make.width.equalToSuperview()
        }
        movieDetailsStackView.snp.makeConstraints { make in
            make.top.equalTo(imageview.snp.bottom)
            make.width.equalToSuperview()
        }
    }
}
