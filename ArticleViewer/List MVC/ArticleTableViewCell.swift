//
//  ArticleTableViewCell.swift
//  ArticleViewer
//
//  Created by Екатерина Сухова on 24/01/17.
//  Copyright © 2017 Екатерина Сухова. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var articleName: UILabel!
    @IBOutlet weak var articleCategory: UILabel!
    @IBOutlet weak var articlePic: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
