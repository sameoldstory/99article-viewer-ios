//
//  ListModel.swift
//  ArticleViewer
//
//  Created by Екатерина Сухова on 25/01/17.
//  Copyright © 2017 Екатерина Сухова. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

struct ArticleProfile {
    let title: String
    let category: String
    let url: String
    let imageUrl: String
    //let pic: UIImage
}

class ListModel {
    private var articleListUrl = "https://99percentinvisible.org/articles/"
    
    private var articles = [ArticleProfile]()
    
    private let articlePattern = "<article class=\"post-block post article\">(\n.+)*</article>"
    private let titlePattern = "<h3 class=\"post-title\">(.*)</h3>"
    private let categoryPattern =  "<p class=\"meta-label\">Category</p>\n.*<p>(.*)</p>"
    private let urlPattern = "<a class=\"post-image\" href=\"(.*)\" style"
    private let imageUrlPattern = "style=\"background-image: url\\('(.*)'\\);"
    

    
    private func returnNewArticleProfile(htmlChunk: String) -> ArticleProfile
    {
        var title = Matcher.getArrayOfMatchingStrings(withPattern: titlePattern, inString: htmlChunk, groupNumber: 1)![0]
        title = HTMLCleaner.turnCodesInSymbols(inString: title)
        let category = Matcher.getArrayOfMatchingStrings(withPattern: categoryPattern, inString: htmlChunk, groupNumber: 1)![0]
        let url = Matcher.getArrayOfMatchingStrings(withPattern: urlPattern, inString: htmlChunk, groupNumber: 1)![0]
        let imageUrl = Matcher.getArrayOfMatchingStrings(withPattern: imageUrlPattern, inString: htmlChunk, groupNumber: 1)![0]
        return ArticleProfile(title: title, category: category, url: url, imageUrl: imageUrl)
    }
    
    func getArticleProfiles(completionHandler: @escaping ([ArticleProfile]) -> ()) {
        Alamofire.request(articleListUrl).responseString { response in
            if let htmlSource = response.result.value {
                if let htmlChunks = Matcher.getArrayOfMatchingStrings(withPattern: self.articlePattern, inString: htmlSource, groupNumber: 0) {
                    for chunk in htmlChunks {
                        let articleProfile = self.returnNewArticleProfile(htmlChunk: chunk)
                        self.articles += [articleProfile]
                    }
                }
            } else {
                print("Didn't get http response")
            }
            completionHandler(self.articles)
        }
    }

}
