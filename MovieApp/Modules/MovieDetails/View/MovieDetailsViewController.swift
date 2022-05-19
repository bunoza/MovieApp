//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 08.10.2021..
//

import UIKit
import Combine

class MovieDetailsViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceHorizontal = true
        collectionView.isScrollEnabled = true
        return collectionView
    }()
    
    init(viewModel : MovieDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        viewModel.didFinish()
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
        let movieDetailsPublishers = viewModel.setupBindings()
        movieDetailsPublishers.0.store(in: &observers)
        movieDetailsPublishers.1.store(in: &observers)
        
        viewModel.output.outputSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [weak self] outputActions in
                for action in outputActions {
                    self?.handle(action)
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
        
        let swipeGestureRecognizerLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeLeft(_:)))
        let swipeGestureRecognizerRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeRight(_:)))
        
        swipeGestureRecognizerLeft.direction = .left
        swipeGestureRecognizerRight.direction = .right
        
        scrollView.addGestureRecognizer(swipeGestureRecognizerLeft)
        scrollView.addGestureRecognizer(swipeGestureRecognizerRight)

        setupCollectionView()
        setupViews()
        setupConstraints()
    }
    
    @objc private func didSwipeLeft(_ sender: UISwipeGestureRecognizer) {
        scrollToNextItem()
    }
    
    @objc private func didSwipeRight(_ sender: UISwipeGestureRecognizer) {
        scrollToPreviousItem()
    }
    
    func scrollToNextItem() {
        if collectionView.indexPathsForVisibleItems.count > 2
        {
            collectionView.setContentOffset(CGPoint(x: collectionView.contentOffset.x + 250, y: 0), animated: true)
        } else
        {
            collectionView.scrollToItem(at: collectionView.indexPathsForVisibleItems[collectionView.indexPathsForVisibleItems.count-1], at: .right, animated: true)
        }
    }
    
    func scrollToPreviousItem() {
        if collectionView.indexPathsForVisibleItems.count > 1
        {
            collectionView.setContentOffset(CGPoint(x: collectionView.contentOffset.x - 250, y: 0), animated: true)
        } else
        {
            collectionView.scrollToItem(at: collectionView.indexPathsForVisibleItems[0], at: .left, animated: true)
        }
    }
    
    func scrollToFrame(scrollOffset : CGFloat) {
        guard scrollOffset <= collectionView.contentSize.width else { return }
        guard scrollOffset >= 0 else { return }
        collectionView.setContentOffset(CGPoint(x: scrollOffset, y: collectionView.contentOffset.y), animated: true)
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
            make.bottom.equalTo(view)
            make.width.equalTo(view)
        }
        imageGradient.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(550)
            make.width.equalTo(view)
            make.top.equalTo(contentView)
        }
        movieDetailsStackView.snp.makeConstraints { make in
            make.top.equalTo(imageGradient.snp.bottom)
            make.width.equalTo(view.snp.width)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(movieDetailsStackView.snp.bottom)
            make.width.equalTo(view)
            make.bottom.equalTo(contentView.snp.bottom)
            make.height.equalTo(200)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.output.screenDataSimilar.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SimilarCollectionViewCell

        cell.configure(imageURL: viewModel.output.screenDataSimilar[indexPath.row].posterPath, title: viewModel.output.screenDataSimilar[indexPath.row].title)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                    
        let cellWidth = 150
        let cellHeight = cellWidth
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
