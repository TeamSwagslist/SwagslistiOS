//
//  OperationsManager.swift
//  Swagslist
//
//  Created by Aidan Brady on 9/24/16.
//  Copyright © 2016 Aidan Brady. All rights reserved.
//

import UIKit

struct Operations
{
    static var loggingIn = false
    static var registering = false
    static var refreshing = false
    
    static var currentOperations = 0
    
    static func setNetworkActivity(activity:Bool)
    {
        if activity
        {
            currentOperations += 1
        }
        else {
            currentOperations -= 1
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = currentOperations > 0
    }
}
