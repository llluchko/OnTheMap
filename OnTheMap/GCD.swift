//
//  GCD.swift
//  OnTheMap
//
//  Created by Latchezar Mladenov on 3/23/16.
//  Copyright © 2016 Latchezar Mladenov. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}