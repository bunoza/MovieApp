//
//  ImageYearGradient.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 20.11.2021..
//

import UIKit
import SnapKit
import Kingfisher

class ImageYearGradient : UIView {
    
    var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
//        imageView.sizeToFit()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let yearLabel : UILabel = {
        let yearLabel = UILabel()
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.numberOfLines = 1
        yearLabel.textColor = .white
        return yearLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        self.addSubview(imageView)
        self.addSubview(yearLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let gradient : CAGradientLayer = {
        let gradient = CAGradientLayer()
        let startColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        let endColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        gradient.colors = [startColor, endColor]
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
        yearLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(imageView.snp.bottom).inset(UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0))
            make.centerX.equalTo(imageView)
        }
    }
    
    func configureImageYearGradient(imageURL: String, year: String) {
        let onImageSet : (Result<RetrieveImageResult, KingfisherError>) -> ()
        onImageSet = { result in
            self.imageView = self.addGradient(toImage: self.imageView)
        }
        imageView.setImageFromUrlwithCompletion(url: imageURL, completion: onImageSet)
        yearLabel.attributedText = NSAttributedString(string: String(year.prefix(4)), attributes: [.font : UIFont.boldSystemFont(ofSize: 15), .foregroundColor : UIColor.white])
    }
}
