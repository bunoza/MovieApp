//
//  FavoriteMoviesViewController.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 04.12.2021..
//

import UIKit
import SnapKit
import Combine
import Tabman


class AttributedMoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate {
    
    let viewModel : AttributedMoviesViewModel

    var observers = Set<AnyCancellable>()
    
    private let refreshControl = UIRefreshControl()
    
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(red: 0.17, green: 0.17, blue: 0.18, alpha: 1.0)
        return tableView
    }()
    
    init(viewModel: AttributedMoviesViewModel) {
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
        view.backgroundColor = UIColor(red: 0.17, green: 0.17, blue: 0.18, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.send(.loading(showLoader: true))
        navigationController?.navigationBar.isHidden = true
        navigationController?.toolbar.isHidden = true
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomCellView.self, forCellReuseIdentifier: "cell")
    }
    
    func setupViews() {
        view.addSubview(tableView)
    }
    
    func setupConstraints(){
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setupView() {
        setupViews()
        setupConstraints()
        setupTableView()
        setupBindings()
        configureRefreshControl()
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
            self.tableView.reloadData()
            print("reload")
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.screenData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomCellView = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCellView
        
        cell.configure(with: viewModel.output.screenData[indexPath.row])
        
        if viewModel.tag == "watched" {
            cell.favoriteButton.isHidden = true
        }
        else if viewModel.tag == "favorites" {
            cell.watchedButton.isHidden = true
        }
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: 0.13, green: 0.13, blue: 0.14, alpha: 1.0)
        cell.selectedBackgroundView = bgColorView
        
        cell.watchedButton.button
            .publisher(for: .touchUpInside)
            .sink { _ in
                self.viewModel.watchedToggle(index: indexPath.row)
            }.store(in: &observers)
        
        cell.favoriteButton.button
            .publisher(for: .touchUpInside)
            .sink { _ in
                self.viewModel.favouriteToggle(index: indexPath.row)
            }.store(in: &observers)
        return cell
    }
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let controller = MovieDetailsViewController(viewModel: MovieDetailsViewModel(movie: viewModel.output.screenData[indexPath.row]))
        controller.modalPresentationStyle = .overCurrentContext
        controller.transitioningDelegate = self
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .white
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}