//
//  Location.swift
//  Golden Hour
//
//  Created by Sam on 10/17/20.
//  Copyright © 2020 Sam. All rights reserved.
//

import RealmSwift

class Location: Object {
    //dynamic : being monitored while running
    @objc dynamic var cityName: String = ""
    @objc dynamic var countryName: String = ""
    @objc dynamic var countryCode: String = ""
    
    //Relationship
    let timestamps = List<Timestamp>()  //Initialize with empty List of Timestamp
}


