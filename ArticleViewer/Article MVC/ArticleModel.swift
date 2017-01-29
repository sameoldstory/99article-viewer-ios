//
//  ArticleModel.swift
//  ArticleViewer
//
//  Created by Екатерина Сухова on 26/01/17.
//  Copyright © 2017 Екатерина Сухова. All rights reserved.
//

import Foundation
import Alamofire

class ArticleModel {
    var articleUrl: String? = nil
    var articleTitle: String? = nil
    
    private let contentPattern = "<div class=\"entry-content page-content\">(\n.*)*<section id=\"engagements\">"
    private let paragraphPattern = "<p>([^<].*)</p>\n"
    
    //private let httpLinkPattern1 = "<a href=\".*\">(.*)</a>"
    //private let httpLinkPattern2 = "<a title="Celeste Olalquiaga" href="http://www.failedarchitecture.com/author/celeste-olalquiaga">Celeste Olalquiaga</a>"
    
    private func formArticleText(paragraphs: [String]) -> String {
        var articleText = ""
        for paragraph in paragraphs {
            articleText.append(paragraph)
            articleText.append("\n")
        }
        return articleText
    }
    
    func getArticleText(completionHandler: @escaping (String) -> ()) {
        Alamofire.request(articleUrl ?? "").responseString { response in
            var text = ""
            if let htmlSource = response.result.value {
                if let content = Matcher.getArrayOfMatchingStrings(withPattern: self.contentPattern, inString: htmlSource, groupNumber: 0),
                    let paragraphs = Matcher.getArrayOfMatchingStrings(withPattern: self.paragraphPattern, inString: content[0], groupNumber: 1) {
                    text = HTMLCleaner.removeHttpLinks(text: self.formArticleText(paragraphs: paragraphs))
                    text = HTMLCleaner.removeMarkUp(string: text)
                    text = HTMLCleaner.turnCodesInSymbols(inString: text)
                }
            } else {
                print("Didn't get http response")
            }
            completionHandler(text)
        }
    }
}








