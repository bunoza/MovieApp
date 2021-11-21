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
    
    var watchedClicked: (() -> ())?
    var favouriteClicked: (() -> ())?

    let imageYearGradient : ImageYearGradient = {
        let imageYearGradient = ImageYearGradient()
        imageYearGradient.translatesAutoresizingMaskIntoConstraints = false
        return imageYearGradient
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
        return buttonStack
    }()
    
    let placeHolderButtonLeft: UIButton = {
        let placeHolderButtonLeft = UIButton()
        placeHolderButtonLeft.translatesAutoresizingMaskIntoConstraints = false
        placeHolderButtonLeft.isUserInteractionEnabled = false
        return placeHolderButtonLeft
    }()
    
    let placeHolderButtonRight: UIButton = {
        let placeHolderButtonRight = UIButton()
        placeHolderButtonRight.translatesAutoresizingMaskIntoConstraints = false
        placeHolderButtonRight.isUserInteractionEnabled = false
        return placeHolderButtonRight
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textContent.addArrangedSubview(title)
        textContent.addArrangedSubview(movieDescription)
        stackview.addArrangedSubview(imageYearGradient)
        stackview.addArrangedSubview(textContent)
        textContent.addArrangedSubview(buttonStack)
        buttonStack.addArrangedSubview(placeHolderButtonLeft)
        buttonStack.addArrangedSubview(placeHolderButtonRight)
        buttonStack.addArrangedSubview(favoriteButton)
        buttonStack.addArrangedSubview(watchedButton)
        contentView.addSubview(stackview)
        contentView.backgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.0)
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
        imageYearGradient.configureImageYearGradient(imageURL: Constants.imageBaseUrl + Constants.defaultPictureSize + movie.posterPath, year: movie.releaseDate)
        self.id = movie.id
        movie.isWatched ? watchedButton.turnOn() : watchedButton.turnOff()
        movie.isFavourite ? favoriteButton.turnOn() : favoriteButton.turnOff()
        self.backgroundColor = UIColor(red: 0.17, green: 0.17, blue: 0.18, alpha: 1.0)
    }
    
    @objc func toggleWatched() {
        watchedClicked?()
    }
    
    @objc func toggleFavorite() {
        favouriteClicked?()
    }
    
    func setupConstraints() {
        imageYearGradient.snp.makeConstraints { (make) in
            make.height.equalTo(170)
            make.width.equalTo(130)
        }
        stackview.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(170)
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20))
        }
    }
}
