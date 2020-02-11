//
//  ViewController.swift
//  TochkaTest
//
//  Created by Сергей Прокопьев on 06/07/2019.
//  Copyright © 2019 PelmondoProduct. All rights reserved.
//

import UIKit
import CoreData

class NewsViewController: UIViewController, NewsBring {
   
    
    fileprivate let cellID = "cell_1"
    fileprivate var news = [Articles]()
    fileprivate var displayNews = [Articles]()
    
    //MARK: - UI Elements
    let tableView : UITableView = {
       let table = UITableView()
       table.translatesAutoresizingMaskIntoConstraints = false
       table.backgroundColor = UIColor(white: 0.95, alpha: 1)
       table.separatorStyle = .none
       table.translatesAutoresizingMaskIntoConstraints = false
       table.rowHeight = UITableView.automaticDimension
       table.estimatedRowHeight = 44
       return table
    }()
    
    let searchBar : UISearchBar = {
        let bar = UISearchBar()
        bar.backgroundColor = #colorLiteral(red: 0, green: 0.8266338706, blue: 1, alpha: 0.67)
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    let decoder = JSONDecoder()
    let api = Network()
    
    //MARK: - View will Apear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getNewsFromCoreData()
        
    }
    // getting news from core data
    func getNews() {
        getNewsFromCoreData()
    }
    
    
    func getNewsFromCoreData() {
        let context = PersistenceServce.context
        let fetchRequest = News.fetchRequest() as NSFetchRequest<News>
        var getNews = [News]()
        do {
            getNews = try context.fetch(fetchRequest)
            print(getNews.count)
        } catch {
            print(error)
        }
        guard let data = getNews.last?.articles else {return}
        do {
            let articles = try decoder.decode(Response.self, from: data)
            news = articles.articles
            displayNews = news
        } catch {
            print(error)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor =  UIColor(white: 0.95, alpha: 1)
        tableView.register(NewsCell.self, forCellReuseIdentifier: cellID)
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        view.addSubview(tableView)
        view.addSubview(searchBar)
        api.getNews()
        api.delegate = self
        setUpLayout()
    }
    

    // MARK: - Layout settings
    fileprivate func setUpLayout() {
        let constraints = [
            //tableView Layout
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            // SearchBar Layout
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 80)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: - Table View Delegate and DataSource
extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayNews.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! NewsCell
    
        let urlToImage = displayNews[indexPath.row].urlToImage
        let author = displayNews[indexPath.row].author
        let info = displayNews[indexPath.row].title
        cell.buttonUrl.tag = indexPath.row
        cell.buttonUrl.addTarget(self, action: #selector(buttonCliked(sender:)), for: .touchUpInside)
        cell.imageUrl = urlToImage
        cell.imageNews.layer.cornerRadius = cell.imageNews.frame.size.width / 2
        cell.authorLabel.text = author
        cell.infoLabel.text = info
        cell.activityInd.startAnimating()
        return cell
    }
    
    @objc func buttonCliked(sender : UIButton) {
        guard let url = URL(string: displayNews[sender.tag].urlToImage) else {return}
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

// Serach Bar settings
extension NewsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        displayNews = news.filter { $0.author.range(of: searchText, options: .caseInsensitive) != nil}
        if searchText == "" {
            displayNews = news
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        displayNews = news
        self.searchBar.text = ""
        self.searchBar.showsCancelButton = false
        tableView.reloadData()
        self.searchBar.resignFirstResponder()
    }
    
}
