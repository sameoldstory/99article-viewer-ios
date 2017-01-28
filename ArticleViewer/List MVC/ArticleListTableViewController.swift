//
//  ArticleListTableViewController.swift
//  ArticleViewer
//
//  Created by Екатерина Сухова on 24/01/17.
//  Copyright © 2017 Екатерина Сухова. All rights reserved.
//

import UIKit

class ArticleListTableViewController: UITableViewController {
    
    var listModel = ListModel()
    
    var articleProfiles = [ArticleProfile]()
    
    let segueIdentifier = "ShowArticleText"
    
    let cellIdentifier = "articleCell"
    
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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleProfiles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Table view cells are reused and should be dequeued using a cell identifier.
        //let cellIdentifier = "articleCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ArticleTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ArticleTableViewCell.")
        }
        
        let article = articleProfiles[indexPath.row]
        
        cell.articleName.text = article.title
        cell.articleCategory.text = article.category
        //cell.articlePic.image = UIImage(named: "Sample1")
        let url = URL(string:article.imageUrl)!
        //cell.articlePic = UIImageView()
        cell.articlePic.af_setImage(withURL: url, placeholderImage: UIImage(named: "Sample1")) { response in
            switch response.result {
            case .success:
                print("Validation Successful")
            case .failure(let error):
                print(error)
            }
        }
        
        return cell

    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == segueIdentifier,
            let destination = segue.destination as? ArticleTextViewController,
            let articleIndex = tableView.indexPathForSelectedRow?.row {
            destination.articleModel.articleUrl = articleProfiles[articleIndex].url
            destination.articleModel.articleTitle = articleProfiles[articleIndex].title
        }
    }
    

}
