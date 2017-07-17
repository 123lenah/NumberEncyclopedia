//
//  DataManager.swift
//  numberApp
//
//  Created by Mac on 6/30/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
enum DataManagerError: Error {
    case Unknown
    case FailedRequest
    case InvalidResponse
}

final class DataManager {
    typealias NumberDataCompletion = (AnyObject?, DataManagerError?) -> ()
    
    //Pass URL into the ddiFetchNumberData function to make the call and parse the JSON 
    func numberDataForNumberAndType(number: String, type: String, completion: @escaping NumberDataCompletion) {
        // fetch URL
        let URL = API.getURLFromString(number: number, type: type)
        
        // create Data task
        URLSession.shared.dataTask(with: URL) { (data, response, error) in
            self.didFetchNumberData(data: data, response: response, error: error, completion: completion)
            
        }.resume()
    }
    
    
    
    
    // Make the Call
    func didFetchNumberData(data: Data?, response: URLResponse?, error: Error?, completion: NumberDataCompletion) {
        if let _ = error {
            completion(nil, .FailedRequest)
        } else if let data = data, let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                processNumberData(data: data, completion: completion)
            } else {
                completion(nil, .FailedRequest)
            }
        } else {
            completion(nil, .Unknown)
        }
    }
    
    
    
    
    // Serialize the JSON
    func processNumberData(data: Data, completion: NumberDataCompletion) {
        if let JSON = try? JSONSerialization.jsonObject(with: data, options: []) {
            completion(JSON as AnyObject?, nil)
        } else {
            completion(nil, .InvalidResponse)
        }
    }
    
    func checkIfValidURL(number: String, type: String, successHandler: @escaping (Bool) -> Void) {
        let url = API.getURLFromString(number: number, type: type)
        
        var success: Bool = true
        let session = URLSession.shared
        let task = session.downloadTask(with:url) { loc, resp, err in
            if let status = (resp as? HTTPURLResponse)?.statusCode {
                if status == 200 {
                    success = true
                    successHandler(success)
                } else {
                    success = false
                    successHandler(success)
                }
                print("response status: \(status)")
            }
            
        }
        task.resume()
    }
}
