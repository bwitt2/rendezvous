//
//  MapViewController.swift
//  Rendezvous
//
//  Created by Connor Giles on 2014-11-08.
//  Copyright (c) 2014 Connor Giles. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    
    //Holds managing container
    var container: ContainerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    
    @IBAction func postEventBtn(sender: AnyObject) {
        container.scrollView!.scrollRectToVisible(container.postView.view.frame, animated: true)
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
