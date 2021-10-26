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
        stackview.alignment = .center
        return stackview
    }()
    
    let textContent: UIStackView = {
        let textContent = UIStackView()
        textContent.translatesAutoresizingMaskIntoConstraints = false
        textContent.axis = .vertical
        textContent.spacing = 10
        textContent.distribution = .fillEqually
        return textContent
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textContent.addArrangedSubview(title)
        textContent.addArrangedSubview(movieDescription)
        stackview.addArrangedSubview(image)
        stackview.addArrangedSubview(textContent)
        contentView.addSubview(stackview)
        contentView.backgroundColor = .darkGray
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
        self.backgroundColor = .systemGray6
    }
    
    func setupConstraints() {
        image.snp.makeConstraints { (make) in
            make.size.equalTo(150)
        }
        stackview.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(170)
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20))
        }
    }
}
