//
//  ArticleTextViewController.swift
//  ArticleViewer
//
//  Created by Екатерина Сухова on 26/01/17.
//  Copyright © 2017 Екатерина Сухова. All rights reserved.
//

import UIKit

class ArticleTextViewController: UIViewController {
    
    var articleModel = ArticleModel()
    
    @IBOutlet weak var articleTitle: UILabel!
    
    @IBOutlet weak var articleText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let title = articleModel.articleTitle ?? "Default name"
        articleTitle.text = title
        //self.view.setNeedsDisplay()
        //navigationItem.title = articleModel.articleName ?? "Default name"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
