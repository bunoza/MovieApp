//
//  BlurLoaderView.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 08.10.2021..
//

import UIKit

class BlurLoaderView: UIView {
    
    var loadingActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        
        indicator.style = .large
        indicator.color = .white
        indicator.startAnimating()
            
        indicator.autoresizingMask = [
            .flexibleLeftMargin, .flexibleRightMargin,
            .flexibleTopMargin, .flexibleBottomMargin
        ]
            
        return indicator
    }()
    
    var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.alpha = 0.8
        blurEffectView.autoresizingMask = [
            .flexibleWidth, .flexibleHeight
        ]
        
        return blurEffectView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setBackgroundColor()
        setupViews()
    }
    
    func setBackgroundColor() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    func setupViews() {
        blurEffectView.frame = self.bounds
        self.insertSubview(blurEffectView, at: 0)
        loadingActivityIndicator.center = CGPoint(
            x: self.bounds.midX,
            y: self.bounds.midY
        )
        self.addSubview(loadingActivityIndicator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
