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
    
    let genres : UILabel = {
        let genres = UILabel()
        genres.translatesAutoresizingMaskIntoConstraints = false
        genres.numberOfLines = 0
        return genres
    }()
    
    let quote : UILabel = {
        let quote = UILabel()
        quote.translatesAutoresizingMaskIntoConstraints = false
        quote.numberOfLines = 0
        quote.attributedText = NSAttributedString(string: "Quote", attributes: [.font : UIFont.boldSystemFont(ofSize: 25), .foregroundColor : UIColor.white])
        return quote
    }()
    
    let quoteText : UILabel = {
        let quoteText = UILabel()
        quoteText.translatesAutoresizingMaskIntoConstraints = false
        quoteText.numberOfLines = 0
        return quoteText
    }()
    
    let descriptionLabel : UILabel = {
        let description = UILabel()
        description.translatesAutoresizingMaskIntoConstraints = false
        description.numberOfLines = 0
        description.attributedText = NSAttributedString(string: "Description", attributes: [.font : UIFont.boldSystemFont(ofSize: 25), .foregroundColor : UIColor.white])
        return description
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
        movieTitle.attributedText = NSAttributedString(string: title, attributes: [.font : UIFont.boldSystemFont(ofSize: 25), .foregroundColor : UIColor.white])
    }
    
    func setGenreText(text : String) {
        genres.attributedText = NSAttributedString(string: text, attributes: [.font : UIFont.systemFont(ofSize: 18), .foregroundColor : UIColor.white])
    }
    
    func setDescriptionText(text : String) {
        quoteText.attributedText = NSAttributedString(string: text, attributes: [.font : UIFont.systemFont(ofSize: 18), .foregroundColor : UIColor.white])
        if text == "\"\"" {
            quoteText.attributedText = NSAttributedString(string: "No quote", attributes: [.font : UIFont.systemFont(ofSize: 18), .foregroundColor : UIColor.white])
        }
    }
    
    func setContentText(text : String) {
        movieOverview.attributedText = NSAttributedString(string: text, attributes: [.font : UIFont.systemFont(ofSize: 18), .foregroundColor : UIColor.white])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        stackview.addArrangedSubview(movieTitle)
        stackview.addArrangedSubview(genres)
        stackview.addArrangedSubview(quote)
        stackview.addArrangedSubview(quoteText)
        stackview.addArrangedSubview(descriptionLabel)
        stackview.addArrangedSubview(movieOverview)
        self.addSubview(stackview)
    }
    
    func setupConstraints(){
        stackview.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10))
        }
    }
}
