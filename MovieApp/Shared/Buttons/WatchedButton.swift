//
//  WatchedButton.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 31.10.2021..
//

import UIKit
import SnapKit

class WatchedButton : UIView {
    
    let defaults = UserDefaults.standard
    
    let button : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "watched_unfilled"), for: .normal)
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
        let watched = defaults.object(forKey: "watched") as? [Int] ?? [Int]()

        if watched.contains(value) {
            button.setImage(UIImage(named: "watched_filled"), for: .normal)
        } else {
            button.setImage(UIImage(named: "watched_unfilled"), for: .normal)
        }
    }
    
    func toggle(value: Int) {
        var tempArray = defaults.object(forKey: "watched") as? [Int] ?? [Int]()

        if button.currentImage == UIImage(named: "watched_unfilled") {
            button.setImage(UIImage(named: "watched_filled"), for: .normal)
            tempArray.append(value)
            defaults.set(tempArray, forKey: "watched")
        } else {
            button.setImage(UIImage(named: "watched_unfilled"), for: .normal)
            tempArray = tempArray.filter {$0 != value}
            defaults.set(tempArray, forKey: "watched")
        }
        print(tempArray)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
