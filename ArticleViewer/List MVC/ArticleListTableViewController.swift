//
//  ArticleListTableViewController.swift
//  ArticleViewer
//
//  Created by Екатерина Сухова on 24/01/17.
//  Copyright © 2017 Екатерина Сухова. All rights reserved.
//

import UIKit

class ArticleListTableViewController: UITableViewController {
    
    private var listModel = ListModel()
    private var articleProfiles = [ArticleProfile]()
    
    private let segueIdentifier = "ShowArticleText"
    private let cellIdentifier = "articleCell"
    
    weak var activityIndicatorView: UIActivityIndicatorView!
    
    private func launchActivityIndicator() {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        tableView.backgroundView = activityIndicatorView
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.activityIndicatorView = activityIndicatorView
        activityIndicatorView.startAnimating()
    }
    
    private func stopActivityIndicatorAndDisplayTable() {
        self.activityIndicatorView.stopAnimating()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        launchActivityIndicator()
        activityIndicatorView.hidesWhenStopped = true
        
        listModel.getArticleProfiles() { profiles in
            self.articleProfiles = profiles
            self.stopActivityIndicatorAndDisplayTable()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleProfiles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ArticleTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ArticleTableViewCell.")
        }
        
        let article = articleProfiles[indexPath.row]
        let url = URL(string:article.imageUrl)!
        
        cell.articleName.text = article.title
        cell.articleCategory.text = article.category
        cell.articlePic.af_setImage(withURL: url, placeholderImage: UIImage(named: "Sample1")) { response in
            switch response.result {
            case .success:
                break
            case .failure(let error):
                print(error)
            }
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier,
            let destination = segue.destination as? ArticleTextViewController,
            let articleIndex = tableView.indexPathForSelectedRow?.row {
            destination.articleModel.articleUrl = articleProfiles[articleIndex].url
            destination.articleModel.articleTitle = articleProfiles[articleIndex].title
        }
    }
    

}
