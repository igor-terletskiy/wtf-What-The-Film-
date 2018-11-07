//
//  ExtensionString.swift
//  FirstPagePosterApp
//
//  Created by Igor on 17.09.2018.
//  Copyright © 2018 Gargolye. All rights reserved.
//

import Foundation

extension String {
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter( )
    }
    
    /**
     This method determines whether the string is included in a substring.
     
     - Parameter sourceString: The period in which the search will take place.
     - Parameter searchString: The string we will look for.
     
     ### Example: ###
     ````
     let string = "biography , comedy , criminal , drama"
     
     let subString_0 = "Comedy"
     searchString( inLine sourceString: string, searchString: subString_0) // return true
     
     let subString_1 = "comedy"
     searchString( inLine sourceString: string, searchString: subString_1) // return true
     
     let subString_2 = "   comedy   "
     searchString( inLine sourceString: string, searchString: subString_2) // return true
     
     let subString_3 = "Com"
     searchString( inLine sourceString: string, searchString: subString_3) // return false
     
     let subString_4 = "comed"
     searchString( inLine sourceString: string, searchString: subString_4) // return false
     
     let subString_5 = "comedyyy"
     searchString( inLine sourceString: string, searchString: subString_5) // return false
     ````
     
     - Returns: If the string contains a substring, return true else return false
     */
    func searchString( inLine sourceString: String, searchString: String) -> Bool {
        var count = 0
        var tempStringArray = [[String]]()
        var tempSubArray = [String]()

        for i in sourceString.lowercased() {
            count += 1
            if i != "," && i != " " {
                tempSubArray.append((String(i)))
            }
            if i == "," || sourceString.count == count {
                tempStringArray.append(tempSubArray)
                tempSubArray.removeAll()
            }
        }
        for value in tempStringArray {
            if value == searchString.map{ String($0)} {
                return true
            }
        }
        return false
    }
    
}
