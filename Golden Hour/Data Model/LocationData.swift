//
//  Location.swift
//  Golden Hour
//
//  Created by Sam on 10/17/20.
//  Copyright © 2020 Sam. All rights reserved.
//

import RealmSwift

class LocationData: Object {
    //dynamic : being monitored while running
    @objc dynamic var cityName: String = ""
    @objc dynamic var countryName: String = ""
    @objc dynamic var countryCode: String = ""
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var latitude: Double = 0.0
        
    //Relationship
    let timestampData = List<TimestampData>()  //Initialize with empty List of Timestamp
}
