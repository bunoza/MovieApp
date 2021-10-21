//
//  UIImageView+Extensions.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 08.10.2021..
//

import Foundation
import UIKit

extension UIImageView {
    func setImageFromUrl(url : String) {
        self.kf.setImage(with: URL(string: url), placeholder: nil, options: [], completionHandler: nil)
    }
}
