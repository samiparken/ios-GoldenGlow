//
//  SunPositionManager.swift
//  Golden Hour
//
//  Created by Sam on 9/2/20.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation

protocol SunPositionManagerDelegate {
    func didUpdateCurrentStatus(_ sunAngle: Double, _ isUp: Bool)
    func didUpdateTodayScan(_ today: [Date])
    func didUpdateRemainingTime(_ remain: Int, _ total: Int)
    func didUpdateSunsetTime(_ sunset: Date)
    func didUpdateSunriseTime(_ sunrise: Date)
}

class SunPositionManager {
    var delegate: SunPositionManagerDelegate?
    var currentData = CurrentData()
    
    
    
    func isAboveEvent() -> Bool
    {
        let sun = currentData.SunAltitude!
        return sun > UPPERLIMIT ? true : false
    }
    func isAboveEvent(_ sun: Double) -> Bool
    {
        return sun > UPPERLIMIT ? true : false
    }
    
    
    func isLowSun() -> Bool
    {
        let sun = currentData.SunAltitude!
        return ( UPPERGOLDEN <= sun ) && ( sun <= UPPERLIMIT ) ? true : false
    }
    func isLowSun(_ sun: Double) -> Bool
    {
        return ( UPPERGOLDEN <= sun ) && ( sun <= UPPERLIMIT ) ? true : false
    }
    
    func isGoldenHour() -> Bool
    {
        let sun = currentData.SunAltitude!
        return ( LOWERGOLDEN <= sun ) && ( sun <= UPPERGOLDEN ) ? true : false
    }
    func isGoldenHour(_ sun: Double) -> Bool
    {
        return ( LOWERGOLDEN <= sun ) && ( sun <= UPPERGOLDEN ) ? true : false
    }
    
    func isBlueHour() -> Bool
    {
        let sun = currentData.SunAltitude!
        return ( LOWERLIMIT <= sun ) && ( sun <= LOWERGOLDEN ) ? true : false
    }
    func isBlueHour(_ sun: Double) -> Bool
    {
        return ( LOWERLIMIT <= sun ) && ( sun <= LOWERGOLDEN ) ? true : false
    }
    
    
    func isBelowEvent() -> Bool
    {
        let sun = currentData.SunAltitude!
        return sun < LOWERLIMIT ? true : false
    }
    func isBelowEvent(_ sun: Double) -> Bool
    {
        return sun < LOWERLIMIT ? true : false
    }

    
    
    func isAboveHorizon() -> Bool
    {
        let sun = currentData.SunAltitude!
        return sun > 0 ? true : false
    }
    func isAboveHorizon(_ sun: Double) -> Bool
    {
        return sun > 0 ? true : false
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
        let now2 = Date() + 10
        let GMT = currentData.GMT
        
        // First Update Sun Altitude & Change
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

        // BG & morning/evening
        self.delegate?.didUpdateCurrentStatus(currentData.SunAltitude!, isSunGoingUp())
        
                
        // Current Scan -> ProgressBar
        

        let today = Date()
        let calendar = Calendar.current
        let yyyy = String(calendar.component(.year, from: today))
        let mm = String(calendar.component(.month, from: today))
        let dd = String(calendar.component(.day, from: today))

        let todayScan: [Date] = dailyScan(yyyy,mm,dd)
        self.delegate?.didUpdateTodayScan(todayScan)
        
        
        
//
//        if( isGoldenHour() )
//        {
//            // BG
//            if ( isAboveHorizon() ) { self.delegate?.didUpdateStatus(1)}
//            else { self.delegate?.didUpdateStatus(-1) }
//
//            let thisTime: [Date] = getTimesForThisGoldenHour()
//            self.delegate?.didUpdateGoldenHour(thisTime)
//
//            let now = Date()
//            let remainingTime = Int(thisTime[1].timeIntervalSince1970 - now.timeIntervalSince1970)
//            let totalTime = Int(thisTime[1].timeIntervalSince1970 - thisTime[0].timeIntervalSince1970)
//            self.delegate?.didUpdateRemainingTime(remainingTime, totalTime)
//        }
//        else
//        {
//            // BG
//            if( isAboveEvent() )
//            { self.delegate?.didUpdateStatus(2) }
//            else if( isBelowEvent() )
//            { self.delegate?.didUpdateStatus(-2)}
//
//            let nextTime: [Date] = getTimesForNextGoldenHour()
//            self.delegate?.didUpdateGoldenHour(nextTime)
//        }
        
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
    
    
    func currentScan() -> [Date] {

        var result: [Date] = []     // result.count == 2

        let GMT = currentData.GMT
        let lon = currentData.Longitude!
        let lat = currentData.Latitude!

        let now = Date()
        let scanLimitDate = now + 86400 // within 24h
        
        let sun = SunPositionModel(now, GMT, longitude: lon, latitude: lat)

        return result
    }
    
    
    func dailyScan(_ year: String, _ month: String, _ day: String) -> [Date] {
        
        var result: [Date] = []     // result.count == 8

        let GMT = currentData.GMT
        let lon = currentData.Longitude!
        let lat = currentData.Latitude!

        let GMTString = String(format: "%+05d", GMT * 100)
        let inputDateString = year + "-" + month + "-" + day + " 00:00:00  " + GMTString
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"  //ex) 2020-03-13 13:37:00 +0100
        let inputDate = dateFormatter.date(from: inputDateString)
        let scanLimitDate = inputDate! + 86400 // within 24h
        
        let sun = SunPositionModel(inputDate!, GMT, longitude: lon, latitude: lat)
        
        repeat {
            sun.spa_calculate()
            let sunAngle = sun.declination
            if ( result.count % 2 == 1 )
            {
                if( isAboveEvent(sunAngle) || isGoldenHour(sunAngle) || isBelowEvent(sunAngle))
                {
                    result.append(sun.date)
                }
            }
            else
            {
                if( isLowSun(sunAngle) || isBlueHour(sunAngle))
                {
                    result.append(sun.date)
                }
            }

            sun.date += calculateTimeGap(sunAngle)   // increase timestamp for scanning
            print("\(year)-\(month)-\(day), \(sunAngle)")
        } while( (sun.date < scanLimitDate) && ( result.count < 8 ) )

        return result
    }
    
    func calculateTimeGap(_ sunAngle: Double) -> Double {
        let absAngle = abs(sunAngle)
        let temp = (absAngle - 10) * 240   // divide 15, multiply 3600
        return ( temp > 60 ) ? temp : 60
    }
        
    
}

// XOR operation for Bool
extension Bool {
    static func ^ (left: Bool, right: Bool) -> Bool {
        return left != right
    }
}
