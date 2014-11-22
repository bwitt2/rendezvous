//
//  LoginViewController.swift
//  Rendezvous
//


import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passField: UITextField!
    
    @IBAction func loginBtn(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(userField.text , password:passField.text) {
            (user: PFUser!, error: NSError!) -> Void in
            if user != nil {
                println("Login Succesful")
                self.performSegueWithIdentifier("afterLogin", sender: self)
            } else {
                println(error.description)
            }
        }
        
    }
    override func viewDidLoad(){
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
