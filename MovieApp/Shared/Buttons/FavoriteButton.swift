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
    
    func turnOn() {
        button.setImage(UIImage(named: "star_filled"), for: .normal)
    }
    
    func turnOff() {
        button.setImage(UIImage(named: "star_unfilled"), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
