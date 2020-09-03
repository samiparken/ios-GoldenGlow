//
//  SunPositionManager.swift
//  Golden Hour
//
//  Created by Sam on 9/2/20.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation

protocol SunPositionManagerDelegate {
    //    func didUpdateNextStartGoldenHour
    //    func didUpdateNextEndGoldenHour
    //    func didUpdatePreviousStartGoldenHour
}

class SunPositionManager {
    
    var delegate: SunPositionManagerDelegate?
    
    var currentData = CurrentData()
    
    func isGoldenHour() -> Bool
    {
        let sun = currentData.SunAltitude!
        if ( ( LOWERLIMIT <= sun ) && ( sun <= UPPERLIMIT ) ) { return true }
        else { return false }
    }
    
    func isAboveGoldenHour() -> Bool
    {
        let sun = currentData.SunAltitude!
        return sun > UPPERLIMIT ? true : false
    }
    
    func isBelowGoldenHour() -> Bool
    {
        let sun = currentData.SunAltitude!
        return sun < LOWERLIMIT ? true : false
    }
    
    func isSunGoingUp() -> Bool
    {
        let change = currentData.SunAltitudeChange!
        return change > 0 ? true : false
    }
    
    func getCurrentAltitude() -> Double
    {
        if let sun = currentData.SunAltitude { return sun }
        else { return 0 }
    }
    
    func updateCurrentAltitude()
    {
        // Get current date & time
        let date = Date()
        let GMT = currentData.GMT
        if let lon = currentData.Longitude
        {
            let lat = currentData.Latitude!
            let sun = SunPositionModel(date, GMT, longitude: lon, latitude: lat)
            sun.spa_calculate()
            if let sunAltitude = currentData.SunAltitude
            {
                currentData.SunAltitudeChange = sun.declination - sunAltitude
            }
            currentData.SunAltitude = sun.declination
        }
    }
    
    func getNextDownEnd(_ target: Double) -> Date
    {
        let date = Date()
        let GMT = currentData.GMT
        let lon = currentData.Longitude!
        let lat = currentData.Latitude!
        let sun = SunPositionModel(date, GMT, longitude: lon, latitude: lat)
        sun.spa_calculate()
        
        if( sun.declination >= target )
        {
            for _ in 0 ... 2880
            {
                sun.date += 30 //increase
                sun.spa_calculate()
                if( sun.declination <= target ) { break }
                print("Sun Altitude : \(sun.declination)")
            }
        }
        else
        {
            for _ in 0 ... 2880
            {
                sun.date += 30 //increase
                sun.spa_calculate()
                if( sun.declination >= target ) { break }
                print("Sun Altitude : \(sun.declination)")
            }
        }
        return sun.date
    }
    
}
