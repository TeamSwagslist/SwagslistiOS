//
//  SharedData.swift
//  Swagslist
//
//  Created by Aidan Brady on 9/24/16.
//  Copyright © 2016 Aidan Brady. All rights reserved.
//

import Foundation

struct SharedData
{
    static var IP:String = "104.236.13.142"
    static var PORT:Int = 29421

    static let SPLITTER:String = "&1&"
    static let SPLITTER_2:String = "&2&"
    static let NEWLINE:String = "&NL&"
    
    static var sessionUsername:String!
    static var sessionPassword:String!
    static var eventList:[EventEntry] = [EventEntry]()
}
