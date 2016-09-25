//
//  Utilities.swift
//  VocabCrack-iOS
//
//  Created by aidancbrady on 12/3/14.
//  Copyright (c) 2014 aidancbrady. All rights reserved.
//

import UIKit

class Utilities
{
    class func displayAlert(controller:UIViewController, title:String, msg:String, action:((UIAlertAction) -> Void)?)
    {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: action)
        
        alertController.addAction(okAction)
        
        controller.present(alertController, animated: true, completion: nil)
    }
    
    class func displayYesNo(controller:UIViewController, title:String, msg:String, action:((UIAlertAction) -> Void)?, cancel:((UIAlertAction) -> Void)?)
    {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: action)
        let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: cancel)
        
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        
        controller.present(alertController, animated: true, completion: nil)
    }
    
    class func displayAction(controller:UIViewController, actions:ActionButton...)
    {
        let alertController = UIAlertController(title:nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        for action in actions
        {
            alertController.addAction(UIAlertAction(title: action.button, style: action.style, handler: action.action))
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        controller.present(alertController, animated: true, completion: nil)
    }
    
    class func displayDialog(controller:UIViewController, title:String, msg:String, actions:ActionButton...)
    {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        for action in actions
        {
            alertController.addAction(UIAlertAction(title: action.button, style: action.style, handler: action.action))
        }
        
        controller.present(alertController, animated: true, completion: nil)
    }
    
    class func displayInput(controller:UIViewController, title:String, msg:String, placeholder:String?, handler:((String) -> Void)?)
    {
        var textField: UITextField?
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {action in
            handler?(textField!.text!)
            return
        }))
        alertController.addTextField(configurationHandler: {(text: UITextField!) in
            text.placeholder = placeholder
            textField = text
        })
        
        controller.present(alertController, animated: true, completion: nil)
    }
    
    /// Whether or not the two strings in their lowercase formats equal each other (trimmed)
    class func trimmedEqual(str1:String, str2:String) -> Bool
    {
        return Utilities.trim(s: str1.lowercased()) == Utilities.trim(s: str2.lowercased())
    }
    
    class func trim(s:String) -> String
    {
        return s.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    
    class func replace(s:String, find:String, replace:String) -> String
    {
        return s.replacingOccurrences(of: find, with: replace, options: [], range: nil)
    }
    
    /// Trims and splits a String with a specified separator
    class func split(s:String, separator:String) -> [String]
    {
        if s.range(of: separator) == nil
        {
            return [trim(s: s)]
        }
        
        var split = trim(s: s).components(separatedBy: separator)
        
        for i in 0 ..< split.count
        {
            if split[i] == ""
            {
                split.remove(at: i)
            }
        }
        
        return split
    }
    
    class func readBool(s:String) -> Bool
    {
        return s == "true"
    }
    
    class func max(num1:Int, num2:Int) -> Int
    {
        return num1 > num2 ? num1 : num2
    }
    
    class func min(num1:Int, num2:Int) -> Int
    {
        return num1 < num2 ? num1 : num2
    }
    
    class func roundButtons(view:UIView)
    {
        for subview in view.subviews
        {
            if subview is UIButton
            {
                let button = subview as! UIButton
                button.layer.cornerRadius = 5
            }
        }
    }
}

class TableDataReceiver: UITableViewController
{
    func receiveData(obj:AnyObject, type:Int) {}
    
    func endRefresh() {}
}

struct ActionButton
{
    var button:String!
    var action:((UIAlertAction) -> Void)?
    var style:UIAlertActionStyle = UIAlertActionStyle.default
    
    init(button:String)
    {
        self.button = button
    }
    
    init(button:String, action:@escaping ((UIAlertAction!) -> Void))
    {
        self.button = button
        self.action = action
    }
    
    init(button:String, action:@escaping ((UIAlertAction!) -> Void), style:UIAlertActionStyle)
    {
        self.button = button
        self.action = action
        self.style = style
    }
}

struct WeakWrapper<T: AnyObject>
{
    weak var value: T?
    
    init(value:T)
    {
        self.value = value
    }
}
