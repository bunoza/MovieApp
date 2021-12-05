//
//  AppDelegate.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 04.10.2021..
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) ->Bool{
        
        let navigationViewController = UINavigationController(rootViewController: TabViewController())
                
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationViewController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    
}

