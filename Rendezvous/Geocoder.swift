//
//  Geocoder.swift
//  Rendezvous
//
//  Created by Brandon Witt on 2014-11-14.
//  Copyright (c) 2014 Connor Giles. All rights reserved.
//

import Foundation

class Geocoder{
    
    private var query: NSString! //the address to be queried
    var latitude: Int! //latitude of current address
    var longitude: Int! //longitude of current address
    private let baseURL: NSString!// base URL for Google Maps Geocoding API
    private let APIKey: NSString!//our API key
    private let params: NSArray = ["address=", "key="]//basic params
    
    init(){
        
        //set that shit to nil
        query = nil
        latitude = nil
        longitude = nil
        //init
        APIKey = "AIzaSyBodzRxtGixKP-Ox9Ut9_KLG6EX0kmy5vo"
        baseURL = "https://maps.googleapis.com/maps/api/geocode/json?"
    }
    
    func getCoordinates(query: NSString){
        var url: NSString = createURL( explode(query) )
        //makeAPICall(url)
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
        
        println(url)
        
        return url
    }
    
    private func explode(string: NSString) -> NSArray{
        //make sure to take out commas
        return string.componentsSeparatedByString(" ")
    }
    
    private func makeAPICall(url: NSString){//make it async
    
        let url: NSURL = NSURL(fileURLWithPath: url)!
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            println("Task completed")
            if(error != nil) {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            var err: NSError?
            
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            if(err != nil) {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
            }
            let results: NSArray = jsonResult["results"] as NSArray

        })
        
        task.resume()
    }
}