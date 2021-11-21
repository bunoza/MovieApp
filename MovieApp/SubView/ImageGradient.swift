//
//  ImageGradient.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 21.11.2021..
//

import UIKit
import SnapKit
import Kingfisher

class ImageGradient : UIView {
    
    var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.sizeToFit()
        return imageView
    }()
    
    let gradient : CAGradientLayer = {
        let gradient = CAGradientLayer()
        let startColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor
        let endColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        gradient.colors = [startColor, endColor]
        return gradient
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        self.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addGradient(toImage: UIImageView) -> UIImageView {
        let imageview = toImage
        gradient.frame = toImage.bounds
        imageview.layer.insertSublayer(gradient, at: 0)
        return imageview
    }
    
    func setupConstraints(){
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    func configureImageGradient(imageURL: String) {
        let onImageSet : (Result<RetrieveImageResult, KingfisherError>) -> ()
        onImageSet = { result in
            print("gradient added")
            self.imageView = self.addGradient(toImage: self.imageView)
            self.imageView.setNeedsLayout()
            self.imageView.layoutIfNeeded()
        }
        imageView.setImageFromUrlwithCompletion(url: imageURL, completion: onImageSet)
        self.imageView = self.addGradient(toImage: self.imageView)

    }
}