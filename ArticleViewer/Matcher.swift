//
//  Matcher.swift
//  Alamofire
//
//  Created by Екатерина Сухова on 28/01/17.
//  Copyright © 2017 Alamofire. All rights reserved.
//

import Foundation

class Matcher {
    static func getArrayOfMatchingStrings(withPattern pattern: String, inString string: String, groupNumber number: Int) -> [String]? {
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
}


    
