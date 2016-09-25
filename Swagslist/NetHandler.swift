//
//  NetHandler.swift
//  VocabCrack
//
//  Created by aidancbrady on 12/2/14.
//  Copyright (c) 2014 aidancbrady. All rights reserved.
//
import Foundation

class NetHandler
{
    class func sendData(str:String) -> String?
    {
        Operations.setNetworkActivity(activity: true)
        
        var inputStream:InputStream?
        var outputStream:OutputStream?
        
        Stream.getStreamsToHost(withName: SharedData.IP, port: SharedData.PORT, inputStream: &inputStream, outputStream: &outputStream)
        
        var writeData = [UInt8]((str + "\n").utf8)
        
        outputStream!.open()
        outputStream!.write(&writeData, maxLength: writeData.count)
        outputStream!.close()
        
        inputStream!.open()
        
        var buffer = [UInt8](repeating:0, count:1048576)
        var bytes = inputStream!.read(&buffer, maxLength: 1024)
        let data = NSMutableData(bytes: &buffer, length: bytes)
        
        while inputStream!.hasBytesAvailable
        {
            let read = inputStream!.read(&buffer, maxLength: 1024)
            bytes += read
            data.append(&buffer, length: read)
        }
        
        inputStream?.close()
        
        Operations.setNetworkActivity(activity: false)
        
        if let str = NSString(bytes: data.bytes, length: bytes, encoding: String.Encoding.utf8.rawValue)
        {
            return str as String
        }
        
        return nil
    }
    
    class func sendDataMultiline(str:String) -> [String]?
    {
        var input:InputStream?
        var output:OutputStream?
        
        Stream.getStreamsToHost(withName: SharedData.IP, port: SharedData.PORT, inputStream: &input, outputStream: &output)
        
        let inputStream = input!
        let outputStream = output!
        
        var data = [UInt8]((str + "\n").utf8)
        
        outputStream.open()
        outputStream.write(&data, maxLength: data.count)
        outputStream.close()
        
        var ret:[String] = [String]()
        
        inputStream.open()
        
        while true
        {
            var buffer = [UInt8](repeating:0, count:1048576)
            var bytes = inputStream.read(&buffer, maxLength: 1024)
            let data = NSMutableData(bytes: &buffer, length: bytes)
            var added = false
            
            while inputStream.hasBytesAvailable
            {
                let read = inputStream.read(&buffer, maxLength: 1024)
                bytes += read
                data.append(&buffer, length: read)
            }
            
            if let str = NSString(bytes: data.bytes, length: bytes, encoding: String.Encoding.utf8.rawValue)
            {
                let split:[String] = Utilities.split(s: str as String, separator: "\n")
                
                for s in split
                {
                    ret.append(s)
                    added = true
                }
            }
            
            if !added
            {
                break
            }
        }
        
        inputStream.close()
        
        if ret.count > 0
        {
            return ret
        }
        
        return nil
    }
    
    class func getEvents() -> [EventEntry]
    {
        var entrySet = [EventEntry]()

        if let response = sendDataMultiline(str: "LISTENTRIES")
        {
            if response.count > 1
            {
                let amount = Int(Utilities.split(s: response[0], separator: SharedData.SPLITTER)[1])!
                
                for i in 0..<amount
                {
                    let entry = EventEntry.createFromCSV(data: Utilities.split(s: response[i+1], separator: SharedData.SPLITTER), start: 0)
                    
                    if entry != nil
                    {
                        entrySet.append(entry!)
                    }
                }
            }
        }
        
        return entrySet
    }
    
    class func login(username:String, password:String) -> Response
    {
        if let response = sendData(str: compileMsg(msg: "AUTH", username, password))
        {
            let split = Utilities.split(s: response, separator: SharedData.SPLITTER)
            
            if split[0] == "ACCEPT"
            {
                SharedData.sessionUsername = username
                return Response.ACCEPT
            }
            else {
                return Response(accept: false, message: split[1])
            }
        }
        
        return Response.ERROR
    }
    
    class func register(username:String, password:String) -> Response
    {
        if let response = sendData(str: compileMsg(msg: "REGISTER", username, password))
        {
            let split = Utilities.split(s: response, separator: SharedData.SPLITTER)
            
            if split[0] == "ACCEPT"
            {
                SharedData.sessionUsername = username
                return Response.ACCEPT
            }
            else {
                return Response(accept: false, message: split[1])
            }
        }
        
        return Response.ERROR
    }
    
    class func addEvent(entry:EventEntry) -> Response
    {
        if let response = sendData(str: compileMsg(msg: "NEWENTRY", entry.toCSV()))
        {
            let split = Utilities.split(s: response, separator: SharedData.SPLITTER)
            return split[0] == "ACCEPT" ? Response.ACCEPT : Response(accept: false, message: split[1])
        }
        
        return Response.ERROR
    }
    
    class func editEvent(origName:String, entry:EventEntry) -> Response
    {
        if let response = sendData(str: compileMsg(msg: "EDITENTRY", origName, entry.toCSV()))
        {
            let split = Utilities.split(s: response, separator: SharedData.SPLITTER)
            return split[0] == "ACCEPT" ? Response.ACCEPT : Response(accept: false, message: split[1])
        }
        
        return Response.ERROR
    }
}

class Response
{
    static let ERROR = Response(accept: false, message: "Error")
    static let ACCEPT = Response(accept: true, message: nil)
    
    var accept:Bool!
    var message:String?
    
    func getAccept() -> Bool
    {
        return accept
    }
    
    init(accept:Bool, message:String?)
    {
        self.accept = accept
        self.message = message
    }
}

func compileMsg(msg:String...) -> String
{
    var ret = ""
    
    if msg.count > 0
    {
        for index in 0...msg.count-1
        {
            ret += msg[index]
            
            if index < msg.count-1
            {
                ret += SharedData.SPLITTER
            }
        }
    }
    
    return ret
}
