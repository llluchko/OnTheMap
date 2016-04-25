//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Latchezar Mladenov on 4/3/16.
//  Copyright © 2016 Latchezar Mladenov. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func loginWith(username: String, password: String, completionHandler: (result: String, errorString: String?) -> Void) {
        let data:[String:AnyObject] = [
            "udacity": [
                "username" : username,
                "password" : password
            ]
        ]
        
        let _ = taskForPostMethod(Constants.AuthorizationURL, method: Methods.Session,jsonBody: data) { (JSONResult , error) in
            if let error = error {
                completionHandler(result: "" , errorString: error.description)
            } else {
                if let result = JSONResult.valueForKey("session") as? [String:String] {
                    if let session = result["id"] {
                        self.sessionID = session
                    }
                } else {
                    completionHandler(result: "", errorString: "Oops! Something went wrong!")
                    print("Failed to parse session from JSON")
                }
                if let account = JSONResult.valueForKey("account") as? NSDictionary {
                    if let userID = account["key"] as? String {
                        self.userID = userID
                        completionHandler(result: "success", errorString: nil)
                    }
                } else {
                    completionHandler(result: "", errorString: "Oops! Something went wrong!")
                    print("Failed to parse userID from JSON")
                }
            }
        }
    }
    
    func getUserInfo(completionHandler: (results: String, errorString: String? ) -> Void) {
        let _ = taskForGetMethod(Methods.UsersID + "/\(userID!)", completionHandler: {(result, error) in
            if let result = result.valueForKey("user") as? [String:AnyObject] {
                if let lastname = result["last_name"] as? String {
                    self.lastName = lastname
                    if let firstname = result["first_name"] as? String {
                        self.firstName = firstname
                        completionHandler(results: "success", errorString: nil)
                    } else {
                        completionHandler(results: "" , errorString: "Oops! Something went wrong!")
                        print("Failed to parse firstname from JSON")
                    }
                } else {
                    completionHandler(results: "" , errorString: "Oops! Something went wrong!")
                    print("Failed to parse lastname from JSON")
                }
            } else {
                completionHandler(results: "" , errorString: "Oops! Something went wrong!")
                print("Failed to parse user from JSON")
            }
        })
    }
    
    func logout(completionHandler: (results: String, errorString: String?) -> Void) {
        let _ = taskForDeleteMethod(Constants.AuthorizationURL, method: Methods.Session) { (JSONResult , error) in
            if let error = error {
                completionHandler(results: "" , errorString: error.description)
            } else {
                if let result = JSONResult.valueForKey("session") as? [String:String] {
                    if let session = result["id"] {
                        self.sessionID = session
                        completionHandler(results: "success", errorString: nil)
                    }
                } else {
                    completionHandler(results: "", errorString: "Oops! Something went wrong!")
                    print("Failed to parse session from JSON")
                }
            }
        }

    }
    
}