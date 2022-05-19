//
//  ViewController.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 04.10.2021..
//

import UIKit
import SnapKit
import Combine


class MovieListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate {
    
    let viewModel : MovieListViewModel
    var observers = Set<AnyCancellable>()
    var buttonObservers = Set<AnyCancellable>()
    private let refreshControl = UIRefreshControl()
    
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = Color.cellViewBackgroundColor
        return tableView
    }()
    
    init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureTitle(title : String) {
        self.navigationItem.title = title
        self.navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTitle(title: "MovieApp")
        setupView()
        viewModel.getRandomMovie()
        view.backgroundColor = Color.cellViewBackgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.send(.loading(showLoader: true))
        navigationController?.navigationBar.isHidden = true
        navigationController?.toolbar.isHidden = true
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieCellView.self, forCellReuseIdentifier: "cell")
    }
    
    func setupViews() {
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setupView() {
        setupViews()
        setupConstraints()
        setupTableView()
        setupBindings()
    }
    
    func setupBindings() {
        viewModel.setupBindings().store(in: &observers)
        
        viewModel.output.outputSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [weak self] outputActions in
                for action in outputActions {
                    self?.handle(action)
                }
            }
            .store(in: &observers)
    }
    
    func configureRefreshControl() {
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc func refreshData() {
        viewModel.input.send(.loading(showLoader: true))
    }
    
    @objc func appMovedToForeground() {
        viewModel.input.send(.loading(showLoader: true))
    }
    
    func handle(_ action: MovieListOutput) {
        switch action {
        case .dataReady:
            self.tableView.reloadData()
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
            print("similar")
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            viewModel.openDetails(
                with: createMovieItemFromDetails(details: viewModel.currentRandomMovie)
            )
            viewModel.getRandomMovie()
        }
    }
    
    func createMovieItemFromDetails(details: MovieDetails) -> MovieItem {
        return MovieItem(
            id: details.id,
            title: details.title,
            overview: details.overview,
            posterPath: details.poster_path,
            releaseDate: details.release_date,
            isFavourite: viewModel.persistance.fetchFavoritesIds().contains(details.id),
            isWatched: viewModel.persistance.fetchWatchedIds().contains(details.id)
        )
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.screenData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell: CustomCellView = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCellView
        let cell: MovieCellView = MovieCellView()
        cell.configure(with: viewModel.output.screenData[indexPath.row])
        
        cell.watchedButton.button
            .publisher(for: .touchUpInside)
            .sink { _ in
                self.viewModel.watchedToggle(index: indexPath.row)
            }.store(in: &buttonObservers)
        
        cell.favoriteButton.button
            .publisher(for: .touchUpInside)
            .sink { _ in
                self.viewModel.favouriteToggle(index: indexPath.row)
            }.store(in: &buttonObservers)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = viewModel.output.screenData[indexPath.row]
        viewModel.openDetails(
            with: createMovieItemFromDetails(details: viewModel.currentRandomMovie)
        )
        viewModel.getRandomMovie()
    }
}
