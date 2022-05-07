//
//  TabViewController.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 04.12.2021..
//

import Tabman
import Pageboy

class TabViewController: TabmanViewController, PageboyViewControllerDataSource, TMBarDataSource, UIViewControllerTransitioningDelegate {
    
    var viewControllers: [UIViewController] = []
    
    func setViewControllers(viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        reloadData()
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index{
        case 0:
            return TMBarItem(title: "Favorites")
        case 1:
            return TMBarItem(title: "Popular")
        case 2:
            return TMBarItem(title: "Watched")
        default:
            return TMBarItem(title: "def")
        }
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

    func setupNavigationAppearance() {
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationAppearance()
        self.dataSource = self
        self.title = ""

        // Create bar
        let bar = TMBar.ButtonBar()
        bar.backgroundView.style = .clear
        bar.layout.transitionStyle = .snap // Customize
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 100.0, bottom: 0.0, right: 100.0)


        // Add to view
        addBar(bar, dataSource: self, at: .bottom)
    }
}
