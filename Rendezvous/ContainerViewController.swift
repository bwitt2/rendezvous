//
//  ContainerViewController.swift
//  Rendezvous
//
//  Created by Connor Giles on 2014-11-08.
//  Copyright (c) 2014 Connor Giles. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var scrollView: UIScrollView?
    
    var mapView: MapViewController!
    var feedView: FeedViewController!
    var postView: PostViewController!
    
    
    override func viewDidAppear(animated: Bool) {
        if(PFUser.currentUser() == nil){
            var user: PFUser = PFUser()
            user.username = "connor"
            user.password = "giles"
            
            //Sign up for user
            /*user.signUpInBackgroundWithBlock({
            (success:Bool!, error:NSError!) -> Void in
            if error == nil{
            println("success!")
            }
            })*/
            
            //Login to existing user
            PFUser.logInWithUsernameInBackground(user.username, password: user.password)

        }
    }
    
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        println("test")
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Create the three views used in the view container
        mapView = MapViewController(nibName: "MapViewController", bundle: nil)
        feedView = FeedViewController(nibName: "FeedViewController", bundle: nil)
        postView = PostViewController(nibName: "PostViewController", bundle: nil)
        
        //Set container object in each view
        
        mapView.container = self
        feedView.container = self
        postView.container = self
        
        //Add in each view to the container view hierarchy
        //Add them in opposite order since the view hieracrhy is a stack
        self.addChildViewController(feedView)
        self.scrollView!.addSubview(feedView.view)
        feedView.didMoveToParentViewController(self)
        
        self.addChildViewController(mapView)
        self.scrollView!.addSubview(mapView.view)
        mapView.didMoveToParentViewController(self)
        
        self.addChildViewController(postView)
        self.scrollView!.addSubview(postView.view)
        postView.didMoveToParentViewController(self)
        
        //Set up the frames of the view controllers to align
        //with eachother inside the container view
        
        mapView.view.frame.origin.x = self.view.frame.width
        feedView.view.frame.origin.x = 2*self.view.frame.width
    
        //Set the size of the scroll view that contains the frames
        var scrollWidth: CGFloat  = 3 * self.view.frame.width
        var scrollHeight: CGFloat  = self.view.frame.size.height
        self.scrollView!.contentSize = CGSizeMake(scrollWidth, scrollHeight)
        
        self.scrollView!.scrollRectToVisible(mapView.view.frame, animated: false)
        
        //Show Facebook Login
        /*let loginView: FBLoginView = FBLoginView()
        loginView.center = self.view.center
        self.view.addSubview(loginView)*/
        
        
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
