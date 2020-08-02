//
//  TextFormatting.swift
//  Country Observer
//
//  Created by Daniel Šuškevič on 2020-08-02.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import Foundation

class TextFormatting {
    
    static let shared = TextFormatting()
    
    func cropString(for text: String, maxWords: Int) -> String {
        var stringsToJoin: [String] = []
        var joinCount = 0
        var maxStringJoins = maxWords
        
        let splitedText = text.split(separator: " ", maxSplits: 4, omittingEmptySubsequences: true).map { String($0) }
        
        if splitedText.count < maxWords {
            maxStringJoins = splitedText.count
        }
        
        while joinCount < maxStringJoins {
            stringsToJoin.append(splitedText[joinCount])
            joinCount += 1
        }
        
        let resultString = stringsToJoin.joined(separator: " ")
        
        return resultString
    }
    
    func cutStringTo(lenght: Int, string: String) -> String {
        let index = string.index(string.startIndex, offsetBy: lenght)
        let mySubstring = string[..<index]
        
        return String(mySubstring)
    }
}
