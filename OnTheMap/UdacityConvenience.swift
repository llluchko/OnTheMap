//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Latchezar Mladenov on 4/3/16.
//  Copyright © 2016 Latchezar Mladenov. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func loginWith(username: String, password: String, completionHandler: (result: String, error: String?) -> Void) {
        let data: [String: AnyObject] = [
            "udacity" : ["username": username, "password": password]
        ]
        
        let _ = taskForPostMethod(Constants.AuthorizationURL, method: Methods.Session, jsonBody: data) { (JSONResult, error) in
            if let error = error {
                completionHandler(result: "", error: error.description)
            } else {
                if let result = JSONResult.valueForKey("session") as? [String: String] {
                    if let session = result["id"] {
                        self.sessionID = session
                    }
                } else {
                    completionHandler(result: "", error: "Failed to parse session from JSON")
                }
                
                if let account = JSONResult.valueForKey("account") as? NSDictionary {
                    if let userID = account["key"] as? String {
                        self.userID = userID
                        completionHandler(result: "success", error: nil)
                    }
                    
                } else {
                    completionHandler(result: "", error: "Failed to parse user id from JSON")
                }
            }
        }
    }
    
    
    func getUserInfo(completionHandler: (results: String, error: String?) -> Void) {
        let _ = taskForGetMethod(Methods.UsersID + "/\(userID!)", completionHandler: { (result, error) in
            if let result = result.valueForKey("user") as? [String: AnyObject] {
                if let lastName = result["lastName"] as? String {
                    self.lastName = lastName
                    if let firstName = result["firstName"] as? String {
                        self.firstName = firstName
                        completionHandler(results: "success", error: nil)
                    } else {
                        completionHandler(results: "", error: "Failed to parse firstName from JSON")
                    }
                } else {
                    completionHandler(results: "", error: "Failed to parse lastName from JSON")
                }
            } else {
                completionHandler(results: "", error: "Failed to parse user from JSON")
            }
        })
    }
    
    
}