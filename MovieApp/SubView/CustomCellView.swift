//
//  CustomCellView.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 08.10.2021..
//

import Foundation
import Kingfisher
import UIKit

class CustomCellView: UITableViewCell {
    
    var id : Int = -1
    let defaults = UserDefaults.standard
    
    let image : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.sizeToFit()
        return image
    }()
    
    let title : UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 2
        return title
    }()
    
    let movieDescription : UILabel = {
        let movieDescription = UILabel()
        movieDescription.translatesAutoresizingMaskIntoConstraints = false
        movieDescription.numberOfLines = 2
        return movieDescription
    }()
    
    let stackview: UIStackView = {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .horizontal
        stackview.spacing = 15
        stackview.distribution = .fillProportionally
        return stackview
    }()
    
    let watchedButton : WatchedButton = {
        let watchedButton = WatchedButton()
        return watchedButton
    }()
    
    let favoriteButton : FavoriteButton = {
        let favoriteButton = FavoriteButton()
        return favoriteButton
    }()
    
    let textContent: UIStackView = {
        let textContent = UIStackView()
        textContent.translatesAutoresizingMaskIntoConstraints = false
        textContent.axis = .vertical
        textContent.spacing = 0
        textContent.distribution = .fillEqually
        return textContent
    }()
    
    let buttonStack: UIStackView = {
        let buttonStack = UIStackView()
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.axis = .horizontal
        buttonStack.spacing = 15
        buttonStack.distribution = .fillProportionally
        buttonStack.alignment = .trailing
        return buttonStack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textContent.addArrangedSubview(title)
        textContent.addArrangedSubview(movieDescription)
        stackview.addArrangedSubview(image)
        stackview.addArrangedSubview(textContent)
        textContent.addArrangedSubview(buttonStack)
        buttonStack.addArrangedSubview(favoriteButton)
        buttonStack.addArrangedSubview(watchedButton)
        contentView.addSubview(stackview)
        contentView.backgroundColor = .darkGray
        watchedButton.button.addTarget(self, action: #selector(toggleWatched), for: .touchUpInside)
        favoriteButton.button.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        contentView.frame = contentView.frame.inset(by: margins)
        contentView.layer.cornerRadius = 15
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with movie: MovieItem) {
        
        title.attributedText = NSAttributedString(string: movie.title, attributes: [.font : UIFont.boldSystemFont(ofSize: 18), .foregroundColor : UIColor.white])
        movieDescription.attributedText = NSAttributedString(string: movie.overview, attributes: [.font : UIFont.systemFont(ofSize: 15), .foregroundColor : UIColor.systemGray4])
        image.setImageFromUrl(url: Constants.imageBaseUrl + Constants.defaultPictureSize + movie.posterPath)
        self.id = movie.id
//        _ = defaults.object(forKey: "favorites") as? [Int] ?? [Int]()
//        _ = defaults.object(forKey: "watched") as? [Int] ?? [Int]()
        
        favoriteButton.toggleOnStart(value: id)
        watchedButton.toggleOnStart(value: id)
        self.backgroundColor = .systemGray6
    }
    
    @objc func toggleWatched() {
        watchedButton.toggle(value: id)
    }
    
    @objc func toggleFavorite() {
        favoriteButton.toggle(value: id)
    }
    
    func setupConstraints() {
        image.snp.makeConstraints { (make) in
            make.height.equalTo(170)
            make.width.equalTo(130)
        }
        stackview.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(170)
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20))
        }
    }
}
