//
//  SetupViewController.swift
//  Rendezvous
//
//  Created by Connor Giles on 2014-11-21.
//  Copyright (c) 2014 Connor Giles. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {

    @IBOutlet weak var FBLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        /*var currentUser = PFUser.currentUser()
        if (currentUser != nil && PFFacebookUtils.isLinkedWithUser(currentUser)) {
        goToApp()
        }*/
        
        //FBLoginButton.layer.cornerRadius = 4;
    }
    
    @IBAction func facebookBtn(sender: AnyObject) {
        
        let permissions = ["public_profile", "email", "user_friends"]
        
        PFFacebookUtils.logInWithPermissions(permissions, {
            (user: PFUser!, error: NSError!) -> Void in
            if user == nil {
                NSLog("Uh oh. The user cancelled the Facebook login.")
            } else if user.isNew {
                
                NSLog("User signed up and logged in through Facebook!")
                self.goToApp()
            } else {
                NSLog("User logged in through Facebook!")
                self.goToApp()
            }
        })
        
    }
    
    func goToApp(){
        NSLog("Login Complete")
        self.performSegueWithIdentifier("afterLogin", sender: self)
    }
    
    override func viewWillAppear(animated: Bool){
        
        //uncomment to remmeber user
        
        /*var currentUser = PFUser.currentUser()
        if (currentUser != nil && PFFacebookUtils.isLinkedWithUser(currentUser)) {
        goToApp()
        }*/
        
        
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
