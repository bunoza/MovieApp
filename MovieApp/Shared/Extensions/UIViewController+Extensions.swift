//
//  UIViewController+Extensions.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 08.10.2021..
//


import UIKit

extension UIViewController {
    
    func showErrorAlert(on viewController: UIViewController) {
        let alert = UIAlertController(title: "Error", message: "Oops, an error has occured.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func showOverlay(on viewController : UIViewController) {
        let blurLoaderOverlay = BlurLoaderOverlay()
        blurLoaderOverlay.showOverlay(on: viewController)
    }
    
    func dismissOverlay(on viewController : UIViewController) {
        let blurLoaderOverlay = BlurLoaderOverlay()
        blurLoaderOverlay.dismissOverlay(on: viewController, flag: false)
    }
}
