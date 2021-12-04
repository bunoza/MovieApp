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
//        viewModel.ready()
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
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: 0.13, green: 0.13, blue: 0.14, alpha: 1.0)
        cell.selectedBackgroundView = bgColorView
        
        cell.watchedClicked = {
            self.viewModel.watchedToggle(value: self.viewModel.output.screenData[indexPath.row])
            if self.viewModel.output.screenData[indexPath.row].isWatched {
                cell.watchedButton.turnOff()
                self.viewModel.output.screenData[indexPath.row].isWatched = false
            } else {
                cell.watchedButton.turnOn()
                self.viewModel.output.screenData[indexPath.row].isWatched = true
            }
        }
        cell.favouriteClicked = {
            self.viewModel.favouriteToggle(value: self.viewModel.output.screenData[indexPath.row])
            if self.viewModel.output.screenData[indexPath.row].isFavourite {
                cell.favoriteButton.turnOff()
                self.viewModel.output.screenData[indexPath.row].isFavourite = false
            } else {
                cell.favoriteButton.turnOn()
                self.viewModel.output.screenData[indexPath.row].isFavourite = true
            }
        }
        if viewModel.output.screenData[indexPath.row].isFavourite {
            cell.favoriteButton.turnOn()
        }
        if viewModel.output.screenData[indexPath.row].isWatched {
            cell.watchedButton.turnOn()
        }
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
