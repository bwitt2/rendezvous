//
//  MapViewController.swift
//  Rendezvous
//
//  Created by Connor Giles on 2014-11-08.
//  Copyright (c) 2014 Connor Giles. All rights reserved.
//

import UIKit
// add this below GMSMapViewDelegate
class MapViewController: UIViewController, GMSMapViewDelegate {
    
    //Holds managing container
    var container: ContainerViewController!
    @IBOutlet weak var mapView: GMSMapView!
    //@IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //test code to laod the map view
        //var target: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 51.6, longitude: 17.2)
        //var camera: GMSCameraPosition = GMSCameraPosition(target: target, zoom: 6, bearing: 0, viewingAngle: 0)
        //if let map = mapView {
        //map.myLocationEnabled = true
            //map.camera = camera
        mapView.delegate = self
            
        //self.view.addSubview(mapView!)
        //}
        
    }
    
    func postPoints(){
        for point in container.locations{
            /*let location = CLLocationCoordinate2D(
                latitude: point.latitude,
                longitude: point.longitude
            )*/
            
            //let annotation = MKPointAnnotation()
            /*annotation.setCoordinate(location)
            annotation.title = "Big Ben"
            annotation.subtitle = "London"*/
            //mapView.addAnnotation(annotation)
            
        }
        
    }
    
    
    @IBAction func postEventBtn(sender: AnyObject) {
        container.scrollView!.scrollRectToVisible(container.postView.view.frame, animated: true)
    }
    @IBAction func refreshFeed(sender: AnyObject) {
        container.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func swipeRight(sender: AnyObject) {
        container.scrollView!.scrollRectToVisible(container.postView.view.frame, animated: true)
    }

    @IBAction func swipeLeft(sender: AnyObject) {
        container.scrollView!.scrollRectToVisible(container.feedView.view.frame, animated: true)
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
