//
//  GooglePlacesAutoComplete.swift
//  Rendezvous
//
//  Created by Brandon Witt on 2014-11-18.
//  Copyright (c) 2014 Connor Giles. All rights reserved.
//

import Foundation
import UIKit

class GooglePlacesAutoComplete: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    private var query: NSString! //the address to be queried
    var latitude: Int! //latitude of current address
    var longitude: Int! //longitude of current address
    private let baseURL: NSString = "https://maps.googleapis.com/maps/api/place/autocomplete/json?" // base URL for Google Maps Geocoding API
    private let APIKey: NSString = "AIzaSyBW383B23YhA7weSXAPhiwbv5vkv2WP4lA" //our API key
    private let params: NSArray = ["input=", "key="]//basic params
    var suggestions: NSMutableArray = NSMutableArray()
    var mapView: MapViewController!
    var place: Place = Place()
    
    //Table View Stuff
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return suggestions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        if indexPath.row < suggestions.count{
            let place: Place = suggestions.objectAtIndex(indexPath.row) as Place
            cell.textLabel.text = place.desc! as String
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if indexPath.row < suggestions.count && mapView.addressInputField != nil{
            let selected: Place = suggestions.objectAtIndex(indexPath.row) as Place
            mapView.addressInputField.text = selected.desc! as String
            self.place = selected
            //getCoordinates(selected)
            mapView.addressInputField.endEditing(true)
        }
    }
    
    func search(query: NSString){
        println("QUERY: \(query)")
        if(query == ""){
        self.suggestions.removeAllObjects()
        }
        var url: NSString = createURL(explode(query) )
        makeAPICall(url)
        self.reloadData()
    }
    
    private func createURL(addressMembers: NSArray) -> String{
        var url: NSString = "\(baseURL)\(params[0])"
        
        for var i = 0; i<addressMembers.count; ++i{
            if(i<addressMembers.count-1){
                url = "\(url)\(addressMembers[i])+"
            }else{
                url = "\(url)\(addressMembers[i])"
            }
        }
        
        url = "\(url)&\(params[1])\(APIKey)"
        
        return url
    }
    
    private func explode(string: NSString) -> NSArray{
        return string.componentsSeparatedByString(" ")
    }
    
    private func makeAPICall(url: NSString){//make it async
        
        let url: NSURL = NSURL(string: url)!

        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
            if let arr = jsonResult["predictions"] as? [NSDictionary]{
                self.suggestions.removeAllObjects()
                for a in arr{
                    let desc: String = a["description"] as String
                    let id: String = a["place_id"] as String
                    
                    let place: Place = Place(place_id: id, description: desc)
                    
                    self.suggestions.addObject(place)
                    //println(self.suggestions.lastObject!)
                }
                
            }
        
        }
        
        task.resume()
        
    }
    
    func getCoordinates(selected: Place){
        
        let place_id: String = selected.placeID
        var lat: Double!
        var lng: Double!
        let url: NSURL = NSURL(string:"https://maps.googleapis.com/maps/api/place/details/json?placeid=\(place_id)&key=\(APIKey)")!
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
            //println("nigga we made it...to this loop")
            //this is possibly the ugliest code ive ever seen.....needs to be fixed, my bad
            //println(jsonResult)
            if(jsonResult["result"] != nil){
                var step1: NSDictionary = jsonResult["result"] as NSDictionary
                var step2 = step1["geometry"] as NSDictionary
                var step3 = step2["location"] as NSDictionary
                
                self.place.lat = step3["lat"] as? Double
                println(self.place.lat)
                
                self.place.lon = step3["lng"] as? Double
                println(self.place.lon)
                
                self.mapView.addPost(self.place)
            }
        }
        
        task.resume()
        
    }
}