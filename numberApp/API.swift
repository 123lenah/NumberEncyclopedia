//
//  API.swift
//  numberApp
//
//  Created by Mac on 6/30/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
struct API {
    // URL structure has type parameters: number, and type. Default for type is trivia
    // Type categories: Trivia, Math, Date, Year
    
    
    
    static func getURLFromString(number: String, type: String) -> URL {
        let urlString = "http://numbersapi.com/\(number)/\(type)?json"
        let urlFromString = URL(string: urlString)!
        return urlFromString
    }
    
    
}
