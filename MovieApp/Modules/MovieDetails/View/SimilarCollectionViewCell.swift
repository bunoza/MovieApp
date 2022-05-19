//
//  SimilarCollectionViewCell.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 02.02.2022..
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

class SimilarCollectionViewCell : UICollectionViewCell {
    
    var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.sizeToFit()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let title : UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 1
        title.clipsToBounds = true
        title.textColor = .white
        title.textAlignment = .center
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        self.addSubview(imageView)
        self.addSubview(title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let gradient : CAGradientLayer = {
        let gradient = CAGradientLayer()
        let startColor = Color.cellGradientStartColor
        let endColor = Color.cellGradientEndColor
        gradient.colors = [startColor!, endColor!]
        return gradient
    }()
    
    func addGradient(toImage: UIImageView) -> UIImageView {
        let imageview = toImage
        gradient.frame = toImage.bounds
        imageview.layer.insertSublayer(gradient, at: 0)
        return imageview
    }
    
    func refreshGradient() {
        imageView = addGradient(toImage: imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.refreshGradient()
    }
    
    func setupConstraints(){
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        title.snp.makeConstraints { (make) in
            make.bottom.equalTo(imageView.snp.bottom).inset(UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0))
            make.left.equalTo(imageView.snp.left).inset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0))
            make.right.equalTo(imageView.snp.right).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5))
        }
    }
    
    func configure(imageURL: String, title: String) {
        let onImageSet : (Result<RetrieveImageResult, KingfisherError>) -> ()
        onImageSet = { result in
            self.imageView = self.addGradient(toImage: self.imageView)
        }
        let url = Constants.imageBaseUrl + Constants.defaultPictureSize + imageURL
        imageView.setImageFromUrlwithCompletion(url: url, completion: onImageSet)
        
        self.title.attributedText = NSAttributedString(string: title, attributes: [.font : UIFont.boldSystemFont(ofSize: 15), .foregroundColor : UIColor.white])
    }
}
