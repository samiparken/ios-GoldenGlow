//
//  Timestamp.swift
//  Golden Hour
//
//  Created by Sam on 10/17/20.
//  Copyright © 2020 Sam. All rights reserved.
//

import RealmSwift

class TimestampData: Object {
    @objc dynamic var time: Date? 
    @objc dynamic var gmt: Double = 0.0
    @objc dynamic var from: Int = 0
    @objc dynamic var fromString: String = ""
    @objc dynamic var to: Int = 0
    @objc dynamic var toString: String = ""
    
    //Relationship
    var parentLocationData = LinkingObjects(fromType: LocationData.self, property: "timestampData")
    
    required init() {

    }
}
