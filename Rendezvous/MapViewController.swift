//
//  MapViewController.swift
//  Rendezvous
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
    var locationManager = CLLocationManager()
    
    var currentLocationIcon: CurrentLocationIcon!
    
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
        
        mapView?.animateToZoom(20)
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
        addCurrentLocationIcon()
        
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
            cameraZoom = 3
            
        }else{
            
            target = CLLocationCoordinate2D(latitude: 0, longitude: 0)
            cameraZoom = 3
            
        }
        var camera: GMSCameraPosition = GMSCameraPosition(target: target, zoom: cameraZoom, bearing: 0, viewingAngle: 0)
        
        if let map = mapView? {
            map.settings.myLocationButton = true
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

    func addCurrentLocationIcon(){
        var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: locationManager.location.coordinate.latitude, longitude: locationManager.location.coordinate.longitude)
            currentLocationIcon = CurrentLocationIcon(mapView: mapView, location: location)
    }
    
    func locationManager(manager: CLLocationManager,  didUpdateLocations locations: NSArray) -> Void {
        var coor: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: locationManager.location.coordinate.latitude, longitude: locationManager.location.coordinate.longitude)
        var cameraPos: GMSCameraPosition = GMSCameraPosition(target: coor,  zoom: 5, bearing: 0, viewingAngle: 0)
        mapView?.animateToCameraPosition(cameraPos)
        currentLocationIcon.update(coor)
    }
}