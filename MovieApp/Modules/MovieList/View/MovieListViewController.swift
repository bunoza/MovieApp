//
//  ViewController.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 04.10.2021..
//

import UIKit
import SnapKit

class MovieListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate {
    
    let viewModel : MovieListViewModel
    
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(red: 0.17, green: 0.17, blue: 0.18, alpha: 1.0)
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
//        navigationController?.navigationBar.barTintColor = UIColor(red: 0.17, green: 0.17, blue: 0.18, alpha: 1.0)
        self.navigationItem.title = title
        self.navigationController?.navigationBar.barStyle = .black
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTitle(title: "MovieApp")
        setupView()
        setupViewModel()
        view.backgroundColor = UIColor(red: 0.17, green: 0.17, blue: 0.18, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.ready()
        super.viewWillAppear(animated)
        
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
    
    func setupViewModel() {
        viewModel.dataReady = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.isLoading = { isLoading in
            if isLoading {
                print("Showing Loader")
            } else {
                print("Dismissing Loader")
            }
        }
        
        viewModel.gotError = { error in
            print(error.localizedDescription)
        }
    }
    
    func setupView() {
        setupViews()
        setupConstraints()
        setupTableView()
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//          return .lightContent
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomCellView = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCellView
        cell.configure(with: viewModel.movies[indexPath.row])
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: 0.13, green: 0.13, blue: 0.14, alpha: 1.0)
        cell.selectedBackgroundView = bgColorView
        cell.watchedClicked = {
            self.viewModel.watchedToggle(value: self.viewModel.movies[indexPath.row])
            if self.viewModel.movies[indexPath.row].isWatched {
                cell.watchedButton.turnOff()
                self.viewModel.movies[indexPath.row].isWatched = false
            } else {
                cell.watchedButton.turnOn()
                self.viewModel.movies[indexPath.row].isWatched = true
            }
        }
        cell.favouriteClicked = {
            self.viewModel.favouriteToggle(value: self.viewModel.movies[indexPath.row])
            if self.viewModel.movies[indexPath.row].isFavourite {
                cell.favoriteButton.turnOff()
                self.viewModel.movies[indexPath.row].isFavourite = false
            } else {
                cell.favoriteButton.turnOn()
                self.viewModel.movies[indexPath.row].isFavourite = true
            }
        }
        if viewModel.movies[indexPath.row].isFavourite {
            cell.favoriteButton.turnOn()
        }
        if viewModel.movies[indexPath.row].isWatched {
            cell.watchedButton.turnOn()
        }
        return cell
    }
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let controller = MovieDetailsViewController(viewModel: MovieDetailsViewModel(movie: viewModel.movies[indexPath.row]))
        controller.modalPresentationStyle = .overCurrentContext
        controller.transitioningDelegate = self
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .white
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
