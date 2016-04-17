//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Latchezar Mladenov on 4/12/16.
//  Copyright © 2016 Latchezar Mladenov. All rights reserved.
//

import Foundation

extension ParseClient {
    
    func getLocations(completionHandler: (results: [StudentLocation]?, error: String?) -> Void) {
        var locations = [StudentLocation]()
        let _ = taskForGetMethod(["limit": "100"], method: "") { (JSONResult, error) in
            if let error = error {
                completionHandler(results: locations, error: error.description)
            } else {
                if let result = JSONResult.valueForKey("results") as? [[String: AnyObject]] {
                    locations = StudentLocation.locationFromResults(result)
                    completionHandler(results: locations, error: nil)
                } else {
                    completionHandler(results: locations, error: "Failed to parse results from JSON")
                }
            }
        }
    }
    
    func postLocations(data: [String: AnyObject], completionHandler: (result: String, error: String?) -> Void) {
       let _ = taskForPostMethod(Constants.BaseURL, method: "", jsonBody: data) { (JSONResult, error) in
            if let error = error {
                completionHandler(result: "", error: error.description)
            } else {
                if let result = JSONResult.valueForKey("createdAt") as? String {
                    completionHandler(result: result, error: nil)
                } else {
                    completionHandler(result: "", error: "Failed to parse object from JSON")
                }
            }
        }
    }
    
}