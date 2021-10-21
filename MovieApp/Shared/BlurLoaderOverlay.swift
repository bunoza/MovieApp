//
//  BlurLoaderOverlay.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 08.10.2021..
//

import UIKit

class BlurLoaderOverlay {
    
    let blurLoaderView : BlurLoaderView = {
        let blurLoaderView = BlurLoaderView()
        blurLoaderView.translatesAutoresizingMaskIntoConstraints = false
        blurLoaderView.tag = 100
        return blurLoaderView
    }()
    
    func showOverlay(on viewController: UIViewController) {
        viewController.view.addSubview(blurLoaderView)
        
        NSLayoutConstraint.activate([
            blurLoaderView.topAnchor.constraint(equalTo: viewController.view.topAnchor),
            blurLoaderView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
            blurLoaderView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            blurLoaderView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor)
        ])
    }
    
    func dismissOverlay(on viewController : UIViewController, flag : Bool) {
        if let viewWithTag = viewController.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }else{
            print("no view with such tag")
        }
    }
    
}
