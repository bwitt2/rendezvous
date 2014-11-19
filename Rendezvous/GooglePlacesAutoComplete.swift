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
    
    /*  WITHOUT THIS WE CAN USE THIS AS OUR TABLE VIEW DELEGATE AND STUFF
    
    With swift I believe we don't need to use an init unless we plan to process some shiat
    
    private var query: NSString! //the address to be queried
    var latitude: Int! //latitude of current address
    var longitude: Int! //longitude of current address
    private let baseURL: NSString!// base URL for Google Maps Geocoding API
    private let APIKey: NSString!//our API key
    private let params: NSArray = ["input=", "key="]//basic params
    var suggestions: NSMutableArray = NSMutableArray()
    
    init(){
        
        //set that shit to nil
        query = nil
        latitude = nil
        longitude = nil
        //init
        APIKey = "AIzaSyBW383B23YhA7weSXAPhiwbv5vkv2WP4lA"
        baseURL = "https://maps.googleapis.com/maps/api/place/autocomplete/json?"
    }
    */
    
    //Table View Stuff
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return suggestions.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        if indexPath.row < suggestions.count{
            cell.textLabel.text = suggestions.objectAtIndex(indexPath.row) as? String
        }
        return cell
    }
    
    func search(query: NSString){
        println("QUERY: \(query)")
        var url: NSString = createURL( explode(query) )
        makeAPICall(url)
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
        
        //println(url)
        
        return url
    }
    
    private func explode(string: NSString) -> NSArray{
        //make sure to take out commas
        return string.componentsSeparatedByString(" ")
    }
    
    private func makeAPICall(url: NSString){//make it async
        
        let url: NSURL = NSURL(string: url)!

        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
            if let arr = jsonResult["predictions"] as? [NSDictionary]{
                self.suggestions.removeAllObjects()
                for a in arr{
                    //println(a["description"]!)
                    let val: String = a["description"] as String
                    self.suggestions.addObject(val)
                    println(self.suggestions.lastObject)
                    self.reloadData()
                }
                
            }
        
        }
        
        task.resume()
        
        reloadData()
        
        
    }
}