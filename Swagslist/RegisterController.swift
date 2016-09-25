//
//  RegisterController.swift
//  Swagslist
//
//  Created by Aidan Brady on 9/24/16.
//  Copyright © 2016 Aidan Brady. All rights reserved.
//

import UIKit

class RegisterController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var registerSpinner: UIActivityIndicatorView!
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        registerButton.addTarget(self, action: #selector(RegisterController.onRegister), for: .touchUpInside)
        
        registerSpinner.isHidden = false
        registerSpinner.hidesWhenStopped = true
        
        usernameField.delegate = self
        passwordField.delegate = self
        confirmField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == usernameField
        {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField
        {
            confirmField.becomeFirstResponder()
        }
        else if textField == confirmField
        {
            confirmField.resignFirstResponder()
            
            onRegister()
        }
        
        return true
    }
    
    @IBAction func backButton(_ sender: AnyObject)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func onRegister()
    {
        if !usernameField.text!.isEmpty && !passwordField.text!.isEmpty
        {
            if passwordField.text == confirmField.text
            {
                doRegister(username: usernameField.text!, password:passwordField.text!)
            }
            else {
                Utilities.displayAlert(controller: self, title: "Warning", msg: "Passwords don't match.", action: nil)
            }
        }
    }
    
    func doRegister(username:String, password:String)
    {
        if Operations.registering
        {
            return
        }
        
        registerSpinner.startAnimating()
        
        DispatchQueue.global(qos: .background).async(execute: {
            Operations.registering = true
            
            let response = NetHandler.register(username: username, password:password)
            
            DispatchQueue.main.async {
                Operations.registering = false
                self.registerSpinner.stopAnimating()
                
                if response.getAccept()
                {
                    Utilities.displayAlert(controller: self, title: "Success", msg: "Successfully registered account, please log in!", action:{(act) -> Void in
                        self.dismiss(animated: true, completion: nil)
                    })
                }
                else {
                    let alertMsg = response.message != nil ? response.message! : "Unable to connect."
                    Utilities.displayAlert(controller: self, title: "Couldn't register", msg: alertMsg, action: nil)
                }
            }
        })
    }
}
