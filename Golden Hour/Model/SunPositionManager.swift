//
//  SunPositionManager.swift
//  Golden Hour
//
//  Created by Sam on 9/2/20.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation

protocol SunPositionManagerDelegate {
    func didUpdateStatus(_ status: Int)   // -1:Night / 0:Golden / 1:Day
    func didUpdateNextGoldenHour(_ next: [Date])
    func didUpdateEndGoldenHour(_ endtime: Date)
    func didUpdateRemainingTime(_ time: Int)
    
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
    
    func startSunPositionSystem()
    {
        // Get current date & time
        let now = Date()
        let now2 = Date() + 5
        let GMT = currentData.GMT
        
        // First Update Sun Altitude
        if let lon = currentData.Longitude
        {
            let lat = currentData.Latitude!
            let sun1 = SunPositionModel(now, GMT, longitude: lon, latitude: lat)
            let sun2 = SunPositionModel(now2, GMT, longitude: lon, latitude: lat)
            sun1.spa_calculate()
            sun2.spa_calculate()
            
            currentData.SunAltitude = sun1.declination
            currentData.SunAltitudeChange = sun2.declination - sun1.declination
        }
        
        updateScreen()
    }
    
    func updateScreen()
    {
        if( isGoldenHour() )
        {
            self.delegate?.didUpdateStatus(0)
            
            let now = Date()
            let endTime: Date = getEndTimeGoldenHour()
            self.delegate?.didUpdateEndGoldenHour(endTime)
            
            let remainingTime = Int(endTime.timeIntervalSince1970 - now.timeIntervalSince1970)
            self.delegate?.didUpdateRemainingTime(remainingTime)
            
        }
        else
        {
            if( isAboveGoldenHour() )
            { self.delegate?.didUpdateStatus(1) }
            else if( isBelowGoldenHour() )
            { self.delegate?.didUpdateStatus(-1)}
            
            let nextTime: [Date] = getTimesForNextGoldenHour()
            self.delegate?.didUpdateNextGoldenHour(nextTime)
        }
    }
    
    
    func updateCurrentAltitude()
    {
        // Get current date & time
        let now = Date()
        let GMT = currentData.GMT
        if let lon = currentData.Longitude
        {
            let lat = currentData.Latitude!
            let sun = SunPositionModel(now, GMT, longitude: lon, latitude: lat)
            sun.spa_calculate()
            
            if let sunAltitude = currentData.SunAltitude //if not first try
            {
                // Save Rate of Sun Altitude Change
                currentData.SunAltitudeChange = sun.declination - sunAltitude
            }
            
            // Save currentSunAltitude
            currentData.SunAltitude = sun.declination
        }
    }
    
    
    func getEndTimeGoldenHour() -> Date
    {
        let time = Date()
        let GMT = currentData.GMT
        let lon = currentData.Longitude!
        let lat = currentData.Latitude!
        let sun = SunPositionModel(time, GMT, longitude: lon, latitude: lat)
        
        for _ in 0 ... 86400
        {
            sun.date += 1
            sun.spa_calculate()
            if ((sun.declination <= LOWERLIMIT) || ( UPPERLIMIT <= sun.declination ))
            {
                break
            }
        }
        return sun.date
    }
    
    
    func getTimesForNextGoldenHour() -> [Date]
    {
        
        var result: [Date] = []
        
        let time = Date()
        let GMT = currentData.GMT
        let lon = currentData.Longitude!
        let lat = currentData.Latitude!
        let sun = SunPositionModel(time, GMT, longitude: lon, latitude: lat)
        
        if( currentData.SunAltitude! >= UPPERLIMIT )
        {
            for i in 0 ... 17280
            {
                sun.date += 5 //increase
                sun.spa_calculate()
                if( (result.count == 0) && (sun.declination <= UPPERLIMIT) )
                {
                    result.append(sun.date)
                }
                else if( (result.count == 1) && ((sun.declination <= LOWERLIMIT) || ( UPPERLIMIT <= sun.declination )) )
                {
                    result.append(sun.date)
                    break
                }
                print(i)
            }
        }
        else if ( currentData.SunAltitude! <= LOWERLIMIT )
        {
            for i in 0 ... 17280
            {
                sun.date += 5 //increase
                sun.spa_calculate()
                if( (result.count == 0) && (sun.declination >= LOWERLIMIT) )
                {
                    result.append(sun.date)
                }
                else if( (result.count == 1) && ((UPPERLIMIT <= sun.declination) || (sun.declination <= LOWERLIMIT)) )
                {
                    result.append(sun.date)
                    break
                }
                print(i)
            }
        }
        
        return result
    }
    
}
