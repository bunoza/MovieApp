//
//  Coordinator.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 12.02.2022..
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinator : [Coordinator] { get set }
    static var navigationController : UINavigationController { get set }
    
    func start()
}
