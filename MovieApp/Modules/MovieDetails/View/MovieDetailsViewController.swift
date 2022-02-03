//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 08.10.2021..
//

import UIKit
import Combine

class MovieDetailsViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let viewModel : MovieDetailsViewModel
    
    var observers = Set<AnyCancellable>()
    var buttonObservers = Set<AnyCancellable>()
    
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
        movieDetailsStackView.backgroundColor = .systemPink
        return movieDetailsStackView
    }()
    
    let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return layout
        }()
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .cyan
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
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
        viewModel.movie.isWatched ? watchedButton.turnOn() : watchedButton.turnOff()
        viewModel.movie.isFavourite ? favoriteButton.turnOn() : favoriteButton.turnOff()
    }
   
    func setupBindings() {
        viewModel.setupBindingsDetails().store(in: &observers)
        viewModel.setupBindingsSimilar().store(in: &observers)
        
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
        
        watchedButton.button
            .publisher(for: .touchUpInside)
            .sink { _ in
                self.viewModel.watchedToggle()
                self.handle(.dataReady)
            }.store(in: &buttonObservers)
        
        favoriteButton.button
            .publisher(for: .touchUpInside)
            .sink { _ in
                self.viewModel.favouriteToggle()
                self.handle(.dataReady)
            }.store(in: &buttonObservers)
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
        case .dataReadySimilar:
            print("similar from controller \(viewModel.output.screenDataSimilar.map{$0.title})")
            collectionView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setupBindings()
        view.backgroundColor = Color.cellViewBackgroundColor
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
        setupCollectionView()
        setupViews()
        setupConstraints()
    }
    
    func setupCollectionView() {
        collectionView.collectionViewLayout = flowLayout
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.register(SimilarCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(imageGradient)
        contentView.addSubview(movieDetailsStackView)
        contentView.insertSubview(watchedButton, aboveSubview: imageGradient)
        contentView.insertSubview(favoriteButton, aboveSubview: imageGradient)
        contentView.addSubview(collectionView)
    }
    
    func setupConstraints(){
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view)
//            make.bottom.equalTo(view)
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
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(movieDetailsStackView.snp.bottom)
            make.height.greaterThanOrEqualTo(100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.output.screenDataSimilar.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SimilarCollectionViewCell
        cell.backgroundColor = .white

        cell.configure(imageURL: viewModel.output.screenDataSimilar[indexPath.row].posterPath, title: viewModel.output.screenDataSimilar[indexPath.row].title)
        return cell
    }
}
