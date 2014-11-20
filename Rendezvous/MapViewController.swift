//
//  MapViewController.swift
//  Rendezvous
//



//I cant seem to get the locationManager.location object to update frequently
//we need to find a way to be notified if there is a change in current location so that we can keep the camera centered on our current lcoation

import UIKit
// add this below GMSMapViewDelegate
class MapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate{
    
    //Outlets
    @IBOutlet weak var mapView: GMSMapView?
    @IBOutlet weak var addressInputField: UITextField!
    @IBOutlet weak var placesObject: GooglePlacesAutoComplete!
    
    //Member Variables
    var container: ContainerViewController! //Holds managing container
    var firstLocationUpdate: Bool?
    var locationManager = CLLocationManager()
    var geocoder: Geocoder = Geocoder()
    var currentLocationIcon: CurrentLocationIcon!
    var markers: NSMutableArray = NSMutableArray()
    
    //Actions
    @IBAction func editingChanged(sender: AnyObject) {
        placesObject.search(addressInputField.text)
        placesObject.reloadData()
    }
    @IBAction func postEventBtn(sender: AnyObject) {
        println("Current Location Post")
    }
    @IBAction func feedBtn(sender: AnyObject) {
        container.scrollView!.scrollRectToVisible(container.feedView.view.frame, animated: true)
    }
    @IBAction func swipeRight(sender: AnyObject) {
        container.scrollView!.scrollRectToVisible(container.postView.view.frame, animated: true)
    }
    @IBAction func swipeLeft(sender: AnyObject) {
        container.scrollView!.scrollRectToVisible(container.feedView.view.frame, animated: true)
    }
    
    //Overrides
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.addressInputField.delegate = self;
        addressInputField.userInteractionEnabled = true
        
        
        mapView?.addSubview(placesObject)
        placesObject.delegate = placesObject
        placesObject.dataSource = placesObject
        placesObject.mapView = self
        
        addCurrentLocationIcon()
        
        locationManager.startUpdatingLocation()
        startMaps()
        loadMarkers()
        
        
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        //does not recognize a touch if the map is what is being touched
        self.view.endEditing(true)
    }
    
    //Optionals
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        geocoder.getCoordinates(textField.text)
        println(textField.text)
        textField.text = ""
        textField.placeholder = "Where's your next rendezvous?"
        
        if(locationManager.location != nil){
            print("lat: ")
            print(locationManager.location.coordinate.latitude)
            print("  lon: ")
            println(locationManager.location.coordinate.longitude)
        }else{
            println("Current location not available.")
        }
        
        return true
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        println("Editing")
        placesObject.alpha = 1
    }
    func textFieldDidEndEditing(textField: UITextField) {
        println("Done Editing")
        placesObject.getCoordinates(placesObject.place)
        placesObject.alpha = 0
        placesObject.suggestions.removeAllObjects()
        placesObject.reloadData()
    }
    
    //Member Functions
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
            loadMarkers()
        }
    }
    func loadMarkers() {
        
        //Remove all markers
        for object in markers {
            let marker: GMSMarker = object as GMSMarker
            marker.map = nil
        }
        
        //Add all markers
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
    func addPost(place: Place) {
        println(placesObject.place.location)
        container.postView.location = placesObject.place.location
        presentViewController(container.postView, animated: true, completion: nil)
        addressInputField.text = ""
        
    }
    func addCurrentLocationIcon(){
        if(locationManager.location != nil){
            var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: locationManager.location.coordinate.latitude, longitude: locationManager.location.coordinate.longitude)
            currentLocationIcon = CurrentLocationIcon(mapView: mapView, location: location)
        }else{
            println("Current Location not available!")
        }
    }
    func locationManager(manager: CLLocationManager,  didUpdateLocations locations: NSArray) -> Void {
        var coor: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: locationManager.location.coordinate.latitude, longitude: locationManager.location.coordinate.longitude)
        
        //Sometimes calls on nil
        currentLocationIcon.updateLocation(coor)
        
        //when the icon changes location we need to make it animate, not redraw at that location
        
    }
}