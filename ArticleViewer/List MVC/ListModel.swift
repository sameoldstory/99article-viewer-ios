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
    //let pic: UIImage
}

class ListModel {
    private var articleListUrl = "https://99percentinvisible.org/articles/"
    
    private var articles = [ArticleProfile]()
    
    private let articlePattern = "<article class=\"post-block post article\">(\n.+)*</article>"
    private let titlePattern = "<h3 class=\"post-title\">(.*)</h3>"
    private let categoryPattern =  "<p class=\"meta-label\">Category</p>\n.*<p>(.*)</p>"
    private let urlPattern = "<a class=\"post-image\" href=\"(.*)\" style"
    
    private func getArrayOfMatchingStrings(withPattern pattern: String, inString string: String, groupNumber number: Int) -> [String]? {
        var matchingStrings = [String]()
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let nsstring = string as NSString
            let matches = regex.matches(in: string, range: NSRange(location: 0, length: nsstring.length))
            for match in matches {
                matchingStrings += [nsstring.substring(with: match.rangeAt(number))]
            }
        } catch {
            print("Regex error")
            return nil
        }
        return matchingStrings
    }
    
    private func returnNewArticleProfile(htmlChunk: String) -> ArticleProfile
    {
        let title = self.getArrayOfMatchingStrings(withPattern: titlePattern, inString: htmlChunk, groupNumber: 1)![0]
        let category = self.getArrayOfMatchingStrings(withPattern: categoryPattern, inString: htmlChunk, groupNumber: 1)![0]
        let url = self.getArrayOfMatchingStrings(withPattern: urlPattern, inString: htmlChunk, groupNumber: 1)![0]
        //self.articles += [ArticleProfile(title: title, category: category, url: url)]
        return ArticleProfile(title: title, category: category, url: url)
    }
    
    func getArticleProfiles(completionHandler: @escaping ([ArticleProfile]) -> ()) {
        Alamofire.request(articleListUrl).responseString { response in
            if let htmlSource = response.result.value {
                if let htmlChunks = self.getArrayOfMatchingStrings(withPattern: self.articlePattern, inString: htmlSource, groupNumber: 0) {
                    for chunk in htmlChunks {
                        let articleProfile = self.returnNewArticleProfile(htmlChunk: chunk)
                        articles += [articleProfile]
                    }
                }
            } else {
                print("Didn't get http response")
            }
            completionHandler(self.articles)
        }
    }

}
