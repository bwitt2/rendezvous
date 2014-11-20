//
//  Place.swift
//  Rendezvous
//
//  Created by Connor Giles on 2014-11-19.
//  Copyright (c) 2014 Connor Giles. All rights reserved.
//

import Foundation

class Place{
    var placeID: String!
    var desc: String!
    var location: PFGeoPoint!
    
    init(){}
    
    init(place_id: String, description: String){
        placeID = place_id
        desc = description
    }
}