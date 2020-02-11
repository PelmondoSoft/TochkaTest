//
//  NewsAPI.swift
//  TochkaTest
//
//  Created by Сергей Прокопьев on 07/07/2019.
//  Copyright © 2019 PelmondoProduct. All rights reserved.
//

import Foundation
import UIKit


struct Response : Decodable {
    let status: String
    let articles: [Articles]
}

struct Articles: Decodable {
    let source: Source
    let author: String
    let title: String
    let urlToImage: String
}

struct Source: Decodable {
    let name: String
}

protocol NewsBring: class {
    func getNews()
}

class Network {
    let myKey = "23301220260a4606a4290ecc2e5b47e9"
    var delegate : NewsBring?
    
    func getNews() {
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=bitcoin&apiKey=\(myKey)") else {return}
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            guard let response = response else {return}
              print(response)
            
            guard let data = data else {return}
            //            print(data)
            
            //CoreData - save
            let savedData = News(context: PersistenceServce.context)
            savedData.articles = data
            
            do {
                try PersistenceServce.context.save()
            } catch {
                print(error)
            }
            self.delegate?.getNews()
            }.resume()
    }
}


