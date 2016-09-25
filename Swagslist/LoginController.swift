//
//  LoginController.swift
//  Swagslist
//
//  Created by Aidan Brady on 9/24/16.
//  Copyright © 2016 Aidan Brady. All rights reserved.
//

import UIKit

class LoginController : UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        activitySpinner.isHidden = false
        activitySpinner.hidesWhenStopped = true
        
        usernameField.delegate = self
        passwordField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == usernameField
        {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField
        {
            passwordField.resignFirstResponder()
            
            onLogin()
        }
        
        return true
    }
    
    @IBAction func loginPressed(_ sender: AnyObject)
    {
        onLogin()
    }
    
    func onLogin()
    {
        if !usernameField.text!.isEmpty && !passwordField.text!.isEmpty
        {
            doLogin(username:usernameField.text!, password:passwordField.text!)
        }
    }
    
    func doLogin(username:String, password:String)
    {
        if Operations.loggingIn
        {
            return
        }
        
        activitySpinner.startAnimating()
        
        DispatchQueue.global(qos: .background).async {
            Operations.loggingIn = true
            
            let response = NetHandler.login(username:username, password:password)
            
            DispatchQueue.main.async {
                Operations.loggingIn = false
                self.activitySpinner.stopAnimating()
                
                if response.getAccept()
                {
                    let menu:UINavigationController = self.storyboard?.instantiateViewController(withIdentifier: "MenuNavigation") as! UINavigationController
                    
                    self.present(menu, animated: true, completion: nil)
                }
                else {
                    let alertMsg:String = response.message != nil ? response.message! : "Unable to connect."
                    
                    Utilities.displayAlert(controller: self, title: "Couldn't login", msg: alertMsg, action: nil)
                }
            }
        }
    }
}
