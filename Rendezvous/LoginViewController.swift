//
//  LoginViewController.swift
//  Rendezvous
//
//  Created by Connor Giles on 2014-11-09.
//  Copyright (c) 2014 Connor Giles. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var loginView: FBLoginView = FBLoginView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*println(PFUser.currentUser().description)
        var currentUser = PFUser.currentUser()
        println(currentUser != nil)
        if (currentUser != nil && PFFacebookUtils.isLinkedWithUser(currentUser)) {
            goToApp()
            println("test")
        }*/
        
    }
    
    @IBAction func facebookBtn(sender: AnyObject) {
        
        let permissions = ["public_profile", "email", "user_friends"]
        
        PFFacebookUtils.logInWithPermissions(permissions, {
            (user: PFUser!, error: NSError!) -> Void in
            if user == nil {
                NSLog("Uh oh. The user cancelled the Facebook login.")
            } else if user.isNew {
                NSLog("User signed up and logged in through Facebook!")
            } else {
                NSLog("User logged in through Facebook!")
            }
            self.goToApp()
        })
        
    }
    
    func goToApp(){
        println("app started")
        self.performSegueWithIdentifier("afterLogin", sender: self)
    }
    
    override func viewWillAppear(animated: Bool){
        
        //SHOULD REDIRECT IF USER IS ALREADY LOGGED IN
        //Need to gigure out why it is'nt
        
        //println(PFUser.currentUser().description)
        var currentUser = PFUser.currentUser()
        println(currentUser != nil)
        if (currentUser != nil && PFFacebookUtils.isLinkedWithUser(currentUser)) {
            goToApp()
            println("test")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
