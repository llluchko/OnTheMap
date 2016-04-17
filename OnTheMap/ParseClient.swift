//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Latchezar Mladenov on 4/3/16.
//  Copyright © 2016 Latchezar Mladenov. All rights reserved.
//

import Foundation

class ParseClient {
    
    var userID: String?
    var sessionID: String?
    
    let session = NSURLSession.sharedSession()
    
    func taskForGetMethod(parameters: [String: String], method: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let urlString = Constants.BaseURL + method + ParseClient.escapedParameters(parameters)
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        
        request.addValue(Constants.ParseAppID, forHTTPHeaderField: HTTPHeader.ParseAppID)
        request.addValue(Constants.ParseAPIKey, forHTTPHeaderField: HTTPHeader.ParseAPIKey)
        
        let task = session.dataTaskWithRequest(request) { data, response, downloadError in
            if let error = downloadError {
                let newError = ParseClient.errorForData(data, response: response, error: error)
                completionHandler(result: nil, error: newError)
            } else {
                ParseClient.parseJSONWithCompletionHandler(data!, completionHandler: completionHandler)
            }
        }
        
        task.resume()
        
        return task
    }
    
    func taskForPostMethod(base: String, method: String, jsonBody: [String: AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        let urlString = base + method
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "POST"
        request.addValue(Constants.ParseAppID, forHTTPHeaderField: HTTPHeader.ParseAppID)
        request.addValue(Constants.ParseAPIKey, forHTTPHeaderField: HTTPHeader.ParseAPIKey)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(jsonBody, options: [])
            
        } catch {
            request.HTTPBody = nil
        }
        
        let task = session.dataTaskWithRequest(request) { data, response, downloadError in
            if downloadError != nil {
                completionHandler(result: nil, error: downloadError)
            } else {
                ParseClient.parseJSONWithCompletionHandler(data!, completionHandler: completionHandler)
            }
        }
        
        task.resume()
 
    }
    
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        var parsingError: NSError? = nil
        let parsedResult: AnyObject?
        
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
        } catch let error as NSError {
            parsingError = error
            parsedResult = nil
        }
        
        if let error = parsingError {
            completionHandler(result: nil, error: error)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }
    
    class func errorForData(data: NSData?, response: NSURLResponse?, error: NSError) -> NSError {
        if let parsedResult = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as? [String : AnyObject] {
            if let errorMessage = parsedResult[ParseClient.JSONResponseKeys.StatusMessage] as? String {
                let userInfo = [NSLocalizedDescriptionKey : errorMessage]
                return NSError(domain: "Parse Error", code: 1, userInfo: userInfo)
            }
        }
        return error
    }
    
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        var urlVars = [String]()
        for (key, value) in parameters {
            let stringValue = "\(value)"
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            urlVars += [key + "=" + "\(escapedValue!)"]
        }
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            static let sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
    
}