//
//  PostViewController.swift
//  Rendezvous
//
//  Created by Connor Giles on 2014-11-08.
//  Copyright (c) 2014 Connor Giles. All rights reserved.
//

import UIKit
import CoreLocation

class PostViewController: UIViewController, UITextFieldDelegate {

    
    var container: ContainerViewController!
    
    @IBOutlet weak var captionField: UITextField!
    @IBOutlet weak var addedTime: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeStepVal: UIStepper!
    
    var location: PFGeoPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set Added Time Label
        addedTime.text = "0 min"
        
        PFGeoPoint.geoPointForCurrentLocationInBackground( {
            (point:PFGeoPoint!, error:NSError!) -> Void in
            
            if point != nil {
                // Succeeding in getting current location
                NSLog("Got current location successfully") // never printed
                
                self.location = point
                
                self.locationLabel.text = "\(point.latitude), \(point.longitude)"
                
            } else {
                // Failed to get location
                NSLog("Failed to get current location") // never printed
            }
        })
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func saveBtn(sender: AnyObject) {
        //Close Keyboard
        self.view.endEditing(true)
        
        //Post to parse
        var post: PFObject = PFObject(className: "Posts")
        post["caption"] = captionField.text
        post["location"] = location
        post["user"] = PFUser.currentUser()
        
        //Create Data object from time stepper
        let date: NSDate = NSDate(timeInterval: NSTimeInterval(5*60*self.timeStepVal.value), sinceDate: NSDate())
        post["expiryTime"] = date
        
        //Reset fields
        captionField.text = ""
        timeStepVal.value = 0
        addedTime.text = "0 min"
        
        post.saveInBackground()
        
        container.scrollView!.scrollRectToVisible(container.mapView.view.frame, animated: true)

    }
    
    //Close keyboard on touch
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    //Close keyboard on return
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        //self.view.endEditing(true)
        return true
    }
    
    @IBAction func timeStepper(sender: AnyObject) {
        addedTime.text = "\(Int(timeStepVal.value)*5) min"
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
