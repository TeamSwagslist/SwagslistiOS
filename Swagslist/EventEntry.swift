//
//  EventEntry.swift
//  Swagslist
//
//  Created by Aidan Brady on 9/24/16.
//  Copyright © 2016 Aidan Brady. All rights reserved.
//

import Foundation

class EventEntry
{
    var name: String!
    var description: String!
    var ownerUsername: String!
    var premium: Bool!
    var latitude: Double!
    var longitude: Double!
    var startTime: UInt64!
    var endTime: UInt64!
    
    var swagSet = [String]()
    
    init() {}
    
    static func createFromCSV(data: [String], start: Int) -> EventEntry?
    {
        let entry = EventEntry()
        
        if data.count-start != 6
        {
            return nil
        }
        
        entry.name = data[start]
        entry.description = Utilities.replace(s: data[start+1], find: SharedData.NEWLINE, replace: "\n")
        entry.ownerUsername = data[start+2]
        entry.premium = data[start+3] == "true"
        entry.latitude = Double(data[start+4])
        entry.longitude = Double(data[start+5])
        entry.startTime = UInt64(data[start+6])
        entry.endTime = UInt64(data[start+7])
        entry.parseSwagSetCSV(csv: data[start+8])
    
        return entry
    }
    
    func toCSV() -> String
    {
        var str = name + SharedData.SPLITTER +
            Utilities.replace(s: description, find: "\n", replace: SharedData.NEWLINE)
        str.append(SharedData.SPLITTER + ownerUsername)
        str.append(SharedData.SPLITTER + String(premium))
        str.append(SharedData.SPLITTER + String(latitude))
        str.append(SharedData.SPLITTER + String(longitude))
        str.append(SharedData.SPLITTER + String(startTime))
        str.append(SharedData.SPLITTER + String(endTime))
        str.append(SharedData.SPLITTER + getSwagSetCSV())
        
        return str
    }
    
    func getSwagSetCSV() -> String
    {
        var ret = ""
        
        for i in 0..<swagSet.count
        {
            ret = ret + swagSet[i] + (i < swagSet.count-1 ? "," : "")
        }
        
        return ret
    }
    
    func parseSwagSetCSV(csv: String)
    {
        swagSet = Utilities.split(s: csv, separator: SharedData.SPLITTER_2)
    }
}
