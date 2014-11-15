//
//  CurrentLocationIcon.swift
//  Rendezvous
//
//  Created by Brandon Witt on 2014-11-14.
//  Copyright (c) 2014 Connor Giles. All rights reserved.
//

import Foundation

class CurrentLocationIcon{
    var radius: CLLocationDistance!
    var center: CLLocationCoordinate2D!
    var map: GMSMapView!
    var circle: GMSCircle!

    init(mapView: GMSMapView?, location: CLLocationCoordinate2D){
        center = location
        map = mapView
        radius = 100000
        circle = GMSCircle(position: center, radius: radius)
        circle.fillColor = UIColor(red:0.25, green:0, blue:0.25, alpha:0.3)
        circle.strokeColor = UIColor.blackColor()
        circle.strokeWidth = 0
        circle.map = mapView
    }
    
    func updateLocation(location: CLLocationCoordinate2D){
        circle.position = location
    }
    
    func updateRadius(radius: CLLocationDistance){
        circle.radius = radius
    }
    
}