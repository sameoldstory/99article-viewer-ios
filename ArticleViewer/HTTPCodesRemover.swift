//
//  HTTPCodesRemover.swift
//  ArticleViewer
//
//  Created by Екатерина Сухова on 28/01/17.
//  Copyright © 2017 Екатерина Сухова. All rights reserved.
//

import Foundation

class HTTPCodesRemover {
    private static let targetSymbol = "&"
    
    //should fill it out later
    private static let codesDict = ["&#8217;":"'", "&nbsp;":" ", "&#8221;":"\"",
                             "&#8220;":"\"", "&#8212;":"—"]
    private static let codePattern = "&.{2,5};"
    
    static func turnCodesInSymbols(inString string: String) -> String {
        var newString = string
        if string.contains(targetSymbol) {
            if let codes = Matcher.getArrayOfMatchingStrings(withPattern: codePattern, inString: string, groupNumber: 0) {
                for code in codes {
                    newString = newString.replacingOccurrences(of: code, with: codesDict[code] ?? code)
                }
            }
        }
        return newString
    }
}
