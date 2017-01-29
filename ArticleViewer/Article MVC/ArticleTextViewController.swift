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
        articleTitle.text = articleModel.articleTitle ?? "Default name"
        articleModel.getArticleText() { text in
            self.articleText.text = text
        }
        //self.view.setNeedsDisplay()
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
