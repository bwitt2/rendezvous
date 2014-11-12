//
//  MapViewController.swift
//  Rendezvous
//
//  Created by Connor Giles on 2014-11-08.
//  Copyright (c) 2014 Connor Giles. All rights reserved.
//


//I cant seem to get the locationManager.location object to update frequently
//we need to find a way to be notified if there is a change in current location so that we can keep the camera centered on our current lcoation

import UIKit
// add this below GMSMapViewDelegate
class MapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate{
    
    //Holds managing container
    var container: ContainerViewController!
    @IBOutlet weak var mapView: GMSMapView?
    @IBOutlet weak var addressInputField: UITextField!
    
    var firstLocationUpdate: Bool?
    let locationManager = CLLocationManager()
    
    @IBAction func currentLocationBtn(sender: AnyObject) {
        
        if(locationManager.location != nil){
            //var location: CLLocation = locationManager.location
            print("lat: ")
            print(locationManager.location.coordinate.latitude)
            print("  lon: ")
            println(locationManager.location.coordinate.longitude)
        }else{
            println("Current location no available.")
        }
        
    }
    
    
    /*override optional func locationManager(_manager: CLLocationManager!,didUpdateLocations locations: [AnyObject]!){
        print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
        print("new loc: ")
        println(_manager.location)
        print("new array loc:")
        println(locations[locations.count-1])
    }*/
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.addressInputField.delegate = self;
        //add the text field as a subview of the mapview
        //mapView?.addSubview(addressInputField)
        addressInputField.userInteractionEnabled = true
        locationManager.startUpdatingLocation()
        startMaps()
        addMarkers()
        
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        println(textField.text)
        textField.text = ""
        textField.placeholder = "Where's your next rendezvous?"
        
        if(locationManager.location != nil){
            //var location: CLLocation = locationManager.location
            print("lat: ")
            print(locationManager.location.coordinate.latitude)
            print("  lon: ")
            println(locationManager.location.coordinate.longitude)
        }else{
            println("Current location not available.")
        }

        
        return true
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        //does not recognize a touch if the map is what is being touched
        self.view.endEditing(true)
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
        
        var cameraZoom: float_t = 5.0
        var target: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        
        if(locationManager.location != nil){
            
            var location: CLLocation = locationManager.location
            target = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            cameraZoom = 12
            
        }else{
            
            target = CLLocationCoordinate2D(latitude: 0, longitude: 0)
            cameraZoom = 4
            
        }
        var camera: GMSCameraPosition = GMSCameraPosition(target: target, zoom: cameraZoom, bearing: 0, viewingAngle: 0)
        
        if let map = mapView? {
            map.myLocationEnabled = true
            map.camera = camera
            map.delegate = self
            addMarkers()
        }
    }
    
    
    func addMarkers() {
        
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