//
//  SignUpViewController.swift
//  Rendezvous
//
//  Created by Connor Giles on 2014-11-21.
//  Copyright (c) 2014 Connor Giles. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passField: UITextField!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
    }
    
    @IBAction func signUpBtn(sender: AnyObject) {
        var user = PFUser()
        user.username = userField.text
        user.password = passField.text
        //user.email = "email@example.com"
        // other fields can be set just like with PFObject
        //user["phone"] = "415-392-0202"
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool!, error: NSError!) -> Void in
            if error == nil {
                println("Sign Up Succesful")
                self.performSegueWithIdentifier("afterLogin", sender: self)
            } else {
                println(error.description)
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
