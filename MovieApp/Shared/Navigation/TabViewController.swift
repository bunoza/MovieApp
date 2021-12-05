//
//  TabViewController.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 04.12.2021..
//

import Tabman
import Pageboy

class TabViewController: TabmanViewController, PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let title = "Page \(index)"
        return TMBarItem(title: title)

    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .at(index: 1)
    }
    

    private var viewControllers = [WatchedMoviesViewController(viewModel: WatchedMoviesViewModel()),
                                   MovieListViewController(viewModel: MovieListViewModel()),
                                   FavoriteMoviesViewController(viewModel: FavoriteMoviesViewModel())]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self

        // Create bar
        let bar = TMBar.ButtonBar()
        bar.backgroundView.style = .clear
        bar.layout.transitionStyle = .snap // Customize
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 100.0, bottom: 0.0, right: 100.0)


        // Add to view
        addBar(bar, dataSource: self, at: .bottom)
    }
}