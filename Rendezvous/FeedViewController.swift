//
//  FeedViewController.swift
//  Rendezvous
//


import UIKit

class FeedCell: UITableViewCell{
    
    @IBOutlet weak var captionLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var photoLbl: UIImageView!
    
}

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var container: ContainerViewController!
    //var posts: PFObject = PFObject(className: "Posts")
    
    var fbID: String!
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var feedTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var nib = UINib(nibName: "FeedCell", bundle: nil)
        
        feedTable.registerNib(nib, forCellReuseIdentifier: "feedCell")
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        feedTable.addSubview(refreshControl)
        
    }
    
    func refresh(sender:AnyObject)
    {
        refreshBegin("Refresh",
            refreshEnd: {(x:Int) -> () in
                self.container.loadData()
                //self.feedTable.reloadData()
                println("Table Reloaded")
                self.refreshControl.endRefreshing()
        })
    }
    func refreshBegin(newtext:String, refreshEnd:(Int) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            println("refreshing")
            sleep(2)
            
            dispatch_async(dispatch_get_main_queue()) {
                refreshEnd(0)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func postEventBtn(sender: AnyObject) {
        container.scrollView!.scrollRectToVisible(container.mapView.view.frame, animated: true)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return container.feedData.count
    }
    @IBAction func settingsBtn(sender: AnyObject) {
        println("Settings")
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        //let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "point")
        //let cell: FeedCellController = FeedCellController(style: UITableViewCellStyle.Default, reuseIdentifier: "point")
        
        let cell: FeedCell = self.feedTable.dequeueReusableCellWithIdentifier("feedCell") as FeedCell
        
        //Get info from Parse
        let point: PFObject = container.feedData.objectAtIndex(indexPath.row) as PFObject
        let loc: PFGeoPoint = point.objectForKey("location") as PFGeoPoint
        let caption: String = point.objectForKey("caption") as String
        
        cell.photoLbl.layer.cornerRadius = cell.photoLbl.frame.width/2
        
        /*  TRYING TO GET PROFILE PICTURES FROM GRAPH
        FBRequestConnection.startForMeWithCompletionHandler(){
            (connection: FBRequestConnection!, result: AnyObject!, error: NSError!)->Void in
            if error != nil{
                self.fbID = result.objectForKey("id") as String
            }
        }
        
        var profilePictureURL: NSURL = NSURL(string: "https://graph.facebook.com/\(fbID)/picture?type=large")!
        var urlRequest: NSURLRequest = NSURLRequest(URL: profilePictureURL, cachePolicy: NSURLRequestCachePolicy(rawValue: UInt(0))!, timeoutInterval: 10.0)
        
        NSURLConnection(request: urlRequest, delegate: self)
        */
        
        //Set labels
        cell.captionLbl.text = caption
        cell.locationLbl.text = "\(loc.latitude), \(loc.longitude)"
        
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
