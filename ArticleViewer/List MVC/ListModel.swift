//
//  ListModel.swift
//  ArticleViewer
//
//  Created by Екатерина Сухова on 25/01/17.
//  Copyright © 2017 Екатерина Сухова. All rights reserved.
//

import Foundation
import Alamofire

struct ArticleProfile {
    let title: String
    let category: String
    let url: String
}

class ListModel {
    private var articleListUrl = "https://99percentinvisible.org/articles/"
    
    private var articles = [ArticleProfile]()
    
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
    
    func getArticleProfiles(completionHandler: @escaping ([ArticleProfile]) -> ()) {
        Alamofire.request(articleListUrl).responseString { response in
            if let htmlSource = response.result.value {
                let pattern = "<article class=\"post-block post article\">(\n.+)*</article>"
                if let htmlChunks = self.getArrayOfMatchingStrings(withPattern: pattern, inString: htmlSource, groupNumber: 0) {
                    let titlePattern = "<h3 class=\"post-title\">(.*)</h3>"
                    let categoryPattern =  "<p class=\"meta-label\">Category</p>\n.*<p>(.*)</p>"
                    let urlPattern = "<a class=\"post-image\" href=\"(.*)\" style"
                    for chunk in htmlChunks {
                        let title = self.getArrayOfMatchingStrings(withPattern: titlePattern, inString: chunk, groupNumber: 1)![0]
                        let category = self.getArrayOfMatchingStrings(withPattern: categoryPattern, inString: chunk, groupNumber: 1)![0]
                        let url = self.getArrayOfMatchingStrings(withPattern: urlPattern, inString: chunk, groupNumber: 1)![0]
                        self.articles += [ArticleProfile(title: title, category: category, url: url)]
                    }
                }
            } else {
                print("Didn't get http response")
            }
            completionHandler(self.articles)
        }
    }

}
