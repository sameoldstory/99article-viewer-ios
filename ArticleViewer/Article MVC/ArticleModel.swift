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
    private let httpLinkPattern = "<a.*>(.*)</a>"
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
    
    private func deleteHttpLinks(text: String) -> String {
        var newText = text
        if let links = Matcher.getArrayOfMatchingStrings(withPattern: httpLinkPattern, inString: text, groupNumber: 0),
            let substitutes = Matcher.getArrayOfMatchingStrings(withPattern: httpLinkPattern, inString: text, groupNumber: 1) {
            for index in 0...links.count-1 {
                newText = newText.replacingOccurrences(of: links[index], with: substitutes[index])
            }
        }
        return newText
    }
    
    func getArticleText() {
        Alamofire.request(articleUrl ?? "").responseString { response in
            if let htmlSource = response.result.value {
                if let content = Matcher.getArrayOfMatchingStrings(withPattern: self.contentPattern, inString: htmlSource, groupNumber: 0),
                    let paragraphs = Matcher.getArrayOfMatchingStrings(withPattern: self.paragraphPattern, inString: content[0], groupNumber: 1) {
                    var text = self.deleteHttpLinks(text: self.formArticleText(paragraphs: paragraphs))
                    text = HTTPCodesRemover.turnCodesInSymbols(inString: text)
                    print("TEXT")
                    print(text)
                }
            } else {
                print("Didn't get http response")
            }
            //completionHandler(self.articles)
        }
    }
}








