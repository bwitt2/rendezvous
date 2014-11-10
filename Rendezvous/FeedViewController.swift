//
//  FeedViewController.swift
//  Rendezvous
//
//  Created by Connor Giles on 2014-11-08.
//  Copyright (c) 2014 Connor Giles. All rights reserved.
//

import UIKit


class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var container: ContainerViewController!
    //var posts: PFObject = PFObject(className: "Posts")
    
    @IBOutlet weak var feedTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func postEventBtn(sender: AnyObject) {
        container.scrollView!.scrollRectToVisible(container.postView.view.frame, animated: true)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return container.feedData.count
    }
    @IBAction func refreshFeed(sender: AnyObject) {
        container.loadData()
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "point")
        
        //Get
        let point: PFObject = container.feedData.objectAtIndex(indexPath.row) as PFObject
        let loc: PFGeoPoint = point.objectForKey("location") as PFGeoPoint
        
        //Find Username
        /*let userQuery: PFQuery = PFQuery(className: "User")
        userQuery.whereKey("objectId", equalTo: point.objectForKey("user").objectId)
        //userQuery.includeKey("user")
        
        var userName: String!

        
        userQuery.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]!, error: NSError!)->Void in
            println(objects.count)
            /*if error == nil && objects.count>0 {
                let user: PFObject = objects[0] as PFObject
                userName = user.objectForKey("username") as String
            }*/
        })*/
        
        //println(point.objectForKey("user").objectId)
        
        cell.textLabel.text = "\(loc.latitude), \(loc.longitude)"
        
        return cell
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
