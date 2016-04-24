//
//  Student.swift
//  OnTheMap
//
//  Created by Latchezar Mladenov on 4/12/16.
//  Copyright © 2016 Latchezar Mladenov. All rights reserved.
//

import Foundation

struct StudentLocation {
    
    var objectID: String
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Double
    var longitude: Double
    var createdAt: String
    var updatedAt: String
    
    init(dictionary: [String: AnyObject]) {
        objectID = dictionary[ParseClient.JSONResponseKeys.objectId] as! String
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.uniqureKey] as! String
        firstName = dictionary[ParseClient.JSONResponseKeys.firstName] as! String
        lastName = dictionary[ParseClient.JSONResponseKeys.lastName] as! String
        mapString = dictionary[ParseClient.JSONResponseKeys.mapString] as! String
        mediaURL = dictionary[ParseClient.JSONResponseKeys.mediaURL] as! String
        latitude = dictionary[ParseClient.JSONResponseKeys.latitude] as! Double
        longitude = dictionary[ParseClient.JSONResponseKeys.longitude] as! Double
        createdAt = dictionary[ParseClient.JSONResponseKeys.createdAt] as! String
        updatedAt = dictionary[ParseClient.JSONResponseKeys.updatedAt] as! String
    }
    

    static func locationFromResults(results: [[String: AnyObject]]) -> [StudentLocation] {
        var locations = [StudentLocation]()
        
        for location in results {
            locations.append(StudentLocation(dictionary: location))
        }
        
        return locations
    }
}