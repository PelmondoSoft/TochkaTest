//
//  NewsCell.swift
//  TochkaTest
//
//  Created by Сергей Прокопьев on 07/07/2019.
//  Copyright © 2019 PelmondoProduct. All rights reserved.
//

import Foundation
import UIKit


class NewsCell : UITableViewCell {
    
    //MARK: - UI Elements
    let infoLabel : UILabel = {
       let label = UILabel()
       label.numberOfLines = 0
       label.font = UIFont.systemFont(ofSize: 16)
       label.text = "TEST"
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
    }()
    
    let authorLabel : UILabel = {
       let label = UILabel()
       label.numberOfLines = 0
       label.font = UIFont.boldSystemFont(ofSize: 20)
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
    }()
    
    let imageNews : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let bubbleBackgroundView : UIView = {
       let view = UIView()
       view.backgroundColor = .white
       view.translatesAutoresizingMaskIntoConstraints = false
       view.layer.cornerRadius = 14
       return view
    }()
    
    let activityInd : UIActivityIndicatorView = {
        let active = UIActivityIndicatorView()
        active.color = .black
        active.backgroundColor = .white
        active.translatesAutoresizingMaskIntoConstraints = false
        return active
    }()
    
    let buttonUrl : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Open image", for: .normal)
        button.backgroundColor = .gray
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    var imageUrl : String? {
        didSet {
            guard let stringUrl = imageUrl else {return}
            guard let url = URL(string: stringUrl) else {return}
            let queue = DispatchQueue.global(qos: .utility)
            queue.async{
                if let data = try? Data(contentsOf: url){
                    DispatchQueue.main.async {
                        self.imageNews.image = UIImage(data: data)
                        self.activityInd.stopAnimating()
//                        print("Show image data")
                    }
//                    print("Did download  image data")
                }
            }
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.activityInd.isHidden = false
        backgroundColor = .clear
        addMySubView()
        setUpLayout()
    }
    
    // add subView
    func addMySubView() {
        addSubview(bubbleBackgroundView)
        addSubview(activityInd)
        addSubview(authorLabel)
        addSubview(infoLabel)
        addSubview(imageNews)
        addSubview(buttonUrl)
    }
    
    // MARK: - Layout settings
    fileprivate func setUpLayout() {
        let constraints = [
            authorLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            authorLabel.bottomAnchor.constraint(equalTo: infoLabel.topAnchor, constant: -5),
            authorLabel.trailingAnchor.constraint(equalTo: imageNews.leadingAnchor, constant: -5),
            authorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            //info
            infoLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: imageNews.leadingAnchor, constant: -5),
            infoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            infoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
//             image view
            imageNews.topAnchor.constraint(equalTo: authorLabel.topAnchor),
            imageNews.bottomAnchor.constraint(equalTo: buttonUrl.topAnchor),
            imageNews.widthAnchor.constraint(equalToConstant: 100),
            imageNews.heightAnchor.constraint(equalToConstant: 100),
            imageNews.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
            // activ ind
            activityInd.topAnchor.constraint(equalTo: imageNews.topAnchor),
            activityInd.bottomAnchor.constraint(equalTo: imageNews.bottomAnchor),
            activityInd.trailingAnchor.constraint(equalTo: imageNews.trailingAnchor),
            activityInd.leadingAnchor.constraint(equalTo: imageNews.leadingAnchor),
            //button to open url
            buttonUrl.topAnchor.constraint(equalTo: imageNews.bottomAnchor),
            buttonUrl.leadingAnchor.constraint(equalTo: imageNews.leadingAnchor),
            buttonUrl.trailingAnchor.constraint(equalTo: imageNews.trailingAnchor),
            buttonUrl.heightAnchor.constraint(equalToConstant: 24),
            buttonUrl.bottomAnchor.constraint(equalTo: infoLabel.bottomAnchor),
            // background layout
            bubbleBackgroundView.topAnchor.constraint(equalTo: authorLabel.topAnchor, constant: -8),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 8),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor, constant: -16),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: imageNews.trailingAnchor, constant: 16)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



