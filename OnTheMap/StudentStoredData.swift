//
//  StudentStoredData.swift
//  OnTheMap
//
//  Created by Latchezar Mladenov on 4/24/16.
//  Copyright © 2016 Latchezar Mladenov. All rights reserved.
//

import Foundation

class StudentStoredData {
    
    var locations: [StudentLocation] = [StudentLocation]()
    
    class func sharedInstance() -> StudentStoredData {
        struct Singleton {
            static var sharedInstance = StudentStoredData()
        }
        return Singleton.sharedInstance
    }

}