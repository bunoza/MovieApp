//
//  MovieDetailsStackView.swift
//  MovieApp
//
//  Created by Domagoj Bunoza on 08.10.2021..
//

import UIKit

class MovieDetailsStackView : UIView{
    
    let movieTitle : UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 0
        return title
    }()
    
    let movieOverview : UILabel = {
        let content = UILabel()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.numberOfLines = 0
        return content
    }()
    
    let stackview: UIStackView = {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.distribution = .fill
        stackview.alignment = .leading
        stackview.spacing = 10
        return stackview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    func setTitleText(title : String) {
        movieTitle.attributedText = NSAttributedString(string: title, attributes: [.font : UIFont.boldSystemFont(ofSize: 17)])
    }
    
    func setContentText(text : String) {
        movieOverview.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        stackview.addArrangedSubview(movieTitle)
        stackview.addArrangedSubview(movieOverview)
        self.addSubview(stackview)
    }
    
    func setupConstraints(){
        stackview.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10))
        }
    }
}
