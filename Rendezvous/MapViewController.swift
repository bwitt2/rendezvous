//
//  MapViewController.swift
//  Rendezvous
//
//  Created by Connor Giles on 2014-11-08.
//  Copyright (c) 2014 Connor Giles. All rights reserved.
//

import UIKit
// add this below GMSMapViewDelegate
class MapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate{
    
    //Holds managing container
    var container: ContainerViewController!
    @IBOutlet weak var mapView: GMSMapView?
    var firstLocationUpdate: Bool?
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        startMaps()
        //addMarkers()
        
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
    
    func startMaps() {
        
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        
        let location: CLLocation = locationManager.location
        
        var target: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        var camera: GMSCameraPosition = GMSCameraPosition(target: target, zoom: 12, bearing: 0, viewingAngle: 0)
        
        if let map = mapView? {
            map.myLocationEnabled = true
            map.camera = camera
            map.delegate = self
            addMarkers()
        }
    }
    
    
    func addMarkers() {
        
        /*var position: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude, longitude: -30)
        var marker: GMSMarker = GMSMarker(position: position)
        marker.title = "Hello World"
        marker.map = mapView*/
        
        var markers: NSMutableArray = NSMutableArray()
        
        for object in container.feedData as NSMutableArray{
            let point:PFObject = object as PFObject
            let location: PFGeoPoint = point.objectForKey("location") as PFGeoPoint
            var position: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let marker: GMSMarker = GMSMarker(position: position)
            marker.map = mapView
            marker.title = point.objectForKey("caption") as String
            markers.addObject(marker)
            
        }

    }
    
}