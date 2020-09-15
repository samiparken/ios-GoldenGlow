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
    func didUpdateGoldenHour(_ next: [Date])
    func didUpdateRemainingTime(_ remain: Int, _ total: Int)
    func didUpdateSunsetTime(_ sunset: Date)
    func didUpdateSunriseTime(_ sunrise: Date)
}

class SunPositionManager {
    var delegate: SunPositionManagerDelegate?
    var currentData = CurrentData()
    
    func isGoldenHour() -> Bool
    {
        let sun = currentData.SunAltitude!
        return ( LOWERLIMIT <= sun ) && ( sun <= UPPERLIMIT ) ? true : false
    }
    
    func isAboveHorizon() -> Bool
    {
        let sun = currentData.SunAltitude!
        return sun > 0 ? true : false
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
        let now2 = Date() + 1
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
            if ( isAboveHorizon() ) { self.delegate?.didUpdateStatus(1)}
            else { self.delegate?.didUpdateStatus(-1) }
            
            let thisTime: [Date] = getTimesForThisGoldenHour()
            self.delegate?.didUpdateGoldenHour(thisTime)

            let now = Date()
            let remainingTime = Int(thisTime[1].timeIntervalSince1970 - now.timeIntervalSince1970)
            let totalTime = Int(thisTime[1].timeIntervalSince1970 - thisTime[0].timeIntervalSince1970)
            self.delegate?.didUpdateRemainingTime(remainingTime, totalTime)
        }
        else
        {
            if( isAboveGoldenHour() )
            { self.delegate?.didUpdateStatus(2) }
            else if( isBelowGoldenHour() )
            { self.delegate?.didUpdateStatus(-2)}
            
            let nextTime: [Date] = getTimesForNextGoldenHour()
            self.delegate?.didUpdateGoldenHour(nextTime)
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
    
    
    func getTimesForThisGoldenHour() -> [Date]
    {
        var result: [Date] = []
        let GMT = currentData.GMT
        let lon = currentData.Longitude!
        let lat = currentData.Latitude!
        let sun = SunPositionModel(Date(), GMT, longitude: lon, latitude: lat)
        
        var currentState = self.isAboveHorizon()
        var passingHorizon: Bool = false
        
        for _ in 0 ... 86400
        {
            sun.date = result.count==0 ? sun.date - 1 : sun.date + 1
            sun.spa_calculate()
            
            if ((sun.declination <= LOWERLIMIT) || ( UPPERLIMIT <= sun.declination ))
            {
                result.append(sun.date)
                sun.date = Date()           //Reset Time
                if( result.count == 2 ) { break }  //End Loop
            }
                // Checking if passing Horizon
            else if ( !passingHorizon && (currentState ^ (sun.declination > 0)))
            {
                passingHorizon = true
                currentState = result.count==0 ? !currentState : currentState //adjust for backwards time
                if(currentState) { self.delegate?.didUpdateSunsetTime(sun.date) } //sunset
                else { self.delegate?.didUpdateSunriseTime(sun.date) } //sunrise
            }
        }
        return result
    }
    
    func getTimesForNextGoldenHour() -> [Date]
    {
        var result: [Date] = []
        
        let GMT = currentData.GMT
        let lon = currentData.Longitude!
        let lat = currentData.Latitude!
        let sun = SunPositionModel(Date(), GMT, longitude: lon, latitude: lat)
        
        var currentState = self.isAboveHorizon()
        
        for i in 0 ... 17280
        {
            sun.date += 5 //increase
            sun.spa_calculate()
            if( (result.count == 0) && (LOWERLIMIT <= sun.declination) && (sun.declination <= UPPERLIMIT))
            {
                result.append(sun.date)
            }
            // Checking if passing Horizon
            else if ( currentState ^ (sun.declination > 0))
            {
                if(currentState) { self.delegate?.didUpdateSunsetTime(sun.date) } //sunset
                else { self.delegate?.didUpdateSunriseTime(sun.date) } //sunrise
                currentState = !currentState
            }
            else if( (result.count == 1) && ((sun.declination <= LOWERLIMIT) || ( UPPERLIMIT <= sun.declination )) )
            {
                result.append(sun.date)
                break
            }
            print(" \(i), \(sun.declination)")
        }
        
        return result
    }
    
}

// XOR operation for Bool
extension Bool {
    static func ^ (left: Bool, right: Bool) -> Bool {
        return left != right
    }
}
