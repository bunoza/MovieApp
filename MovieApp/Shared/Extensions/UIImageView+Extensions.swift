//
//  UIImageView+Extensions.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 08.10.2021..
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    func setImageFromUrl(url : String) {
        self.kf.setImage(with: URL(string: url), options: [], completionHandler: nil)
    }
    
    func setImageFromUrlwithCompletion(url : String,  completion: @escaping (Result<RetrieveImageResult, KingfisherError>) -> ()) {
        self.kf.setImage(with: URL(string: url), options: [], completionHandler: completion)
    }
}
