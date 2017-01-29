//
//  HTTPCodesRemover.swift
//  ArticleViewer
//
//  Created by Екатерина Сухова on 28/01/17.
//  Copyright © 2017 Екатерина Сухова. All rights reserved.
//

import Foundation

// TO DO
// leave some other meaningful mark up (e.g. lists)
// improve processing of links (case with multiple links in the paragraph)

class HTMLCleaner {
    private static let targetSymbol = "&"
    
    private static let codesDict = ["&#8217;":"'", "&nbsp;":" ", "&#8221;":"\"",
                             "&#8220;":"\"", "&#8212;":"—", "&#038;":"&",
                             "&rsquo;":"'", "&#8211;":"—"]
    private static let codePattern = "&.{2,5};"
    private static let httpLinkPattern = "<a.*>(.*)</a>"
    private static let markUpPattern = "<.*>"
    
    static func turnCodesInSymbols(inString string: String) -> String {
        var newString = string
        if string.contains(targetSymbol) {
            if let codes = Matcher.getArrayOfMatchingStrings(withPattern: codePattern, inString: string, groupNumber: 0) {
                for code in codes {
                    newString = newString.replacingOccurrences(of: code, with: codesDict[code] ?? "")
                }
            }
        }
        return newString
    }
    
    static func removeHttpLinks(text: String) -> String {
        var newText = text
        if let links = Matcher.getArrayOfMatchingStrings(withPattern: httpLinkPattern, inString: text, groupNumber: 0),
            let substitutes = Matcher.getArrayOfMatchingStrings(withPattern: httpLinkPattern, inString: text, groupNumber: 1) {
            for index in 0...links.count-1 {
                newText = newText.replacingOccurrences(of: links[index], with: substitutes[index])
            }
        }
        return newText
    } 
    
    static func removeMarkUp(string: String) -> String {
        var newString = string
        if let markUp = Matcher.getArrayOfMatchingStrings(withPattern: markUpPattern, inString: string, groupNumber: 0) {
            for item in markUp {
                newString = newString.replacingOccurrences(of: item, with: "")
            }
        }
        return newString
    }
}
