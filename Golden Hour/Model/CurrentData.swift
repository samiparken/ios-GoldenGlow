//
//  CurrentData.swift
//  Golden Hour
//
//  Created by Sam on 9/3/20.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation

struct CurrentData {

    var GMT: Double = Double(TimeZone.current.secondsFromGMT()) / 3600
    var Longitude: Double?
    var Latitude: Double?
    var SunAltitude: Double?
    var SunAltitudeChange: Double?   //Rate of Change
    
}
