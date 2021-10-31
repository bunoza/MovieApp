//
//  FavoriteButton.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 31.10.2021..
//

import UIKit
import SnapKit
import SwiftUI

class FavoriteButton : UIView {
    
    let defaults = UserDefaults.standard
    
    let button : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "star_unfilled"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        self.addSubview(button)
    }
    
    func setupConstraints() {
        button.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    func toggleOnStart(value: Int){
        let favorites = defaults.object(forKey: "favorites") as? [Int] ?? [Int]()

        if favorites.contains(value) {
            button.setImage(UIImage(named: "star_filled"), for: .normal)
        } else {
            button.setImage(UIImage(named: "star_unfilled"), for: .normal)
        }
        
    }
    
    func toggle(value: Int) {
        var tempArray = defaults.object(forKey: "favorites") as? [Int] ?? [Int]()

        if button.currentImage == UIImage(named: "star_unfilled") {
            button.setImage(UIImage(named: "star_filled"), for: .normal)
            tempArray.append(value)
            defaults.set(tempArray, forKey: "favorites")
        } else {
            button.setImage(UIImage(named: "star_unfilled"), for: .normal)
            tempArray = tempArray.filter {$0 != value}
            defaults.set(tempArray, forKey: "favorites")
        }
        print(tempArray)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
