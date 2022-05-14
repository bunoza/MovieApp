//
//  ParentCoordinatorDelegate.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 04.10.2021..
//

import Foundation

protocol ParentCoordinatorDelegate: Coordinator { }

extension ParentCoordinatorDelegate where Self: Coordinator {
    func childDidFinish(_ coordinator: Coordinator) {
        for (index, coord) in childCoordinators.enumerated() {
            if coord === coordinator {
                childCoordinators.remove(at: index)
                print("Coordinator \(coordinator) removed.")
            }
        }
    }
}
