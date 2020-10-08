//
//  TabBarController.swift
//  Golden Hour
//
//  Created by Sam on 9/21/20.
//  Copyright © 2020 Sam. All rights reserved.
//

import UIKit

// Keys for Notification & Observers
let CityNameUpdateNotificationKey = "co.samiparken.updateCityName"
let BGImageUpdateNotificationKey = "co.samiparken.updateBGImage"
let TimerUpdateNotificationKey = "co.samiparken.updateTimer"
let SunAngleUpdateNotificationKey = "co.samiparken.updateSunAngle"
let MorningEveningReadyNotificationKey = "co.samiparken.morningEveningReady"

class TabBarController: UITabBarController {
    
    static let singletonTabBar = TabBarController()
    
    /* for Sharing Data Btw View Controllers */
    // BG & Location
    var BGImageViewName: String?
    var currentLocation: String?
    
    // SkyView1 Timer
    var currentState: String = ""
    var nextState: String = ""
    var timerHour: String = ""
    var timerMin: String = ""
    var timerSec: String = ""
    var sunAngle: Double = 0.0
    var sunPulsePosition: CGFloat = 0.0
    var wavePosition: CGFloat = 0.0
    
    // SkyView2 Switch
    var isEvening: Bool = true
    var isToday: Bool = true
    
    // SkyView2 Center Data
    var sunriseTime: String = ""
    var sunsetTime: String = ""
    var morningTotalTime: String = ""
    var eveningTotalTime: String = ""
    
    // SkyView2 Times
    var morningCellData: [CellData] = []   // 5 x 2 + 1 = 13
    var eveningCellData: [CellData] = []   // 5 x 2 + 1 = 13
    
    // Managers
    var sunPositionManager = SunPositionManager()
    var locationManager = LocationManager()
    var timerManager = TimerManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegates
        sunPositionManager.delegate = self
        locationManager.delegate = self
        timerManager.delegate = self
        
    }
    
    func updateSunAngle() {
        sunPositionManager.updateCurrentAltitude()
        let tempAngle = sunPositionManager.getAltitude()
        
        if tempAngle != sunAngle
        {
            sunAngle = tempAngle
            // Braodcast
            let keyName = Notification.Name(rawValue: SunAngleUpdateNotificationKey)
            NotificationCenter.default.post(name: keyName, object: nil)
        }
    }
    
    func calculateTotalDuration(_ data: [CellData]) -> String {
        if (data.count > 2)
        {
            let lastIndex = data.count - 1
            let start = data[0].time!
            let end = data[lastIndex].time!
            
            let _duration = Int((end.timeIntervalSince1970 - start.timeIntervalSince1970) / 60)
            return String(format: "%dmin", _duration)
        }
        else
        {
            return "ERROR"
        }
    }
    
    
}


//MARK: - SunPositionManagerDelegate
extension TabBarController: SunPositionManagerDelegate {
    
    // Set BG & Current/Next State & morning/evening
    func didUpdateCurrentState(_ sunAngle: Double, _ isUp: Bool) {
        
        //BG update
        switch sunAngle {
        case -90 ..< -6 : BGImageViewName = "BG_Night";
            currentState = "NIGHTTIME";
            nextState = "BLUE HOUR";
            isEvening = false; isToday = isUp ? true : false
            sunPulsePosition = 0.8 ;  wavePosition = 0.5
        case -6  ..< -4 : BGImageViewName = "BG_Blue";
            currentState = "BLUE HOUR";
            nextState = isUp ? "GOLDEN HOUR-" : "NIGHTTIME";
            isEvening = isUp ? false : true;
            sunPulsePosition = 0.7 ; wavePosition = 0.5
        case -4  ..< -0.5  : BGImageViewName = "BG_Golden-";
            currentState = "GOLDEN HOUR -";
            nextState = isUp ? "SUNRISE" : "BLUE HOUR";
            isEvening = isUp ? false : true
            sunPulsePosition = 0.6 ; wavePosition = 0.5
        case -0.5 ..< 0.5 : BGImageViewName = "BG_Golden-";
            currentState = isUp ? "SUNRISE" : "SUNSET";
            nextState = isUp ? "GOLDEN HOUR +" : "GOLDEN HOUR -";
            isEvening = isUp ? false : true;
            sunPulsePosition = 0.6 ; wavePosition = 0.5
        case 0.5   ..< 6  : BGImageViewName = "BG_Golden+";
            currentState = "GOLDEN HOUR +";
            nextState = isUp ? "LOW SUN" : "SUNSET";
            isEvening = isUp ? false : true;
            sunPulsePosition = 0.5 ; wavePosition = 0.6
        case 6   ..< 10 : BGImageViewName = "BG_LowSun";
            currentState = "LOW SUN";
            nextState = isUp ? "DAYTIME" : "GOLDEN HOUR +"
            isEvening = isUp ? false : true
            sunPulsePosition = 0.3; wavePosition = 0.7
        default         : BGImageViewName = "BG_Day";
            currentState = "DAYTIME"
            nextState = "LOW SUN"
            isEvening = true
            sunPulsePosition = 0.15; wavePosition = 0.8
        }
        // Broadcast
        let keyName = Notification.Name(rawValue: BGImageUpdateNotificationKey)
        NotificationCenter.default.post(name: keyName, object: nil)
        
        //SunAngle update
        updateSunAngle()
    }
    
    func didUpdateCurrentScan(from: Date, to: Date, _ nowState: Int, _ nextState: Int) {
        
        //TotalDuration
        let duration = to.timeIntervalSince1970 - from.timeIntervalSince1970
        
        //remaining
        let remaining = to.timeIntervalSince1970 - Date().timeIntervalSince1970
        
        //percent
        let percent = remaining / duration * 100
        
        // Start Timer
        timerManager.toTime = to
        timerManager.startTimer()
    }
    
    func didUpdateTodayScan(_ today: [SunTimestamp]) {
        
        var timestamp: [SunTimestamp] = today
        var end:Date, start: Date
        var currentState = timestamp[0].to
        
        // Morning scan
        while( (timestamp.count > 0) )
        {
            start = timestamp[0].time
            if (timestamp[0].to == SETRISE) {
                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: start)
                let minute = calendar.component(.minute, from: start)
                sunriseTime = String(format: "%02d:%02d", hour, minute)
            }
            let newTimeCellData = CellData( time: start )
            morningCellData.append(newTimeCellData)
            
            timestamp.removeFirst(1)
            if( (timestamp.count == 0) || (currentState == DAYTIME)) { break }
            else {
                end = timestamp[0].time
                let _duration = Int((end.timeIntervalSince1970 - start.timeIntervalSince1970) / 60)
                let durationString = String(format: "%dmin", _duration)
                let newTitleCellData = CellData(state: currentState, duration: durationString, isEvening: false)
                morningCellData.append(newTitleCellData)
                
                currentState = timestamp[0].to
            }
        }
        
        // Morning Total Duration
        morningTotalTime = calculateTotalDuration(morningCellData)

        
        // Evening Scan
        if( timestamp.count > 0 ) { currentState = timestamp[0].to }
        while( (timestamp.count > 0) )
        {
            start = timestamp[0].time
            if (timestamp[0].to == SETRISE) {
                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: start)
                let minute = calendar.component(.minute, from: start)
                sunsetTime = String(format: "%02d:%02d", hour, minute)
            }
            let newTimeCellData = CellData( time: start )
            eveningCellData.append(newTimeCellData)
            
            timestamp.removeFirst(1)
            if( (timestamp.count == 0) || (currentState == NIGHTTIME)) { break }
            else {
                end = timestamp[0].time
                let _duration = Int((end.timeIntervalSince1970 - start.timeIntervalSince1970) / 60)
                let durationString = String(format: "%dmin", _duration)
                let newTitleCellData = CellData(state: currentState, duration: durationString, isEvening: true)
                eveningCellData.append(newTitleCellData)
                
                currentState = timestamp[0].to
            }
        }
        
        
        // Evening Total Duration
        eveningTotalTime = calculateTotalDuration(eveningCellData)
        
        // Get SkyView2 Ready
        // Broadcast
        let keyName2 = Notification.Name(rawValue: MorningEveningReadyNotificationKey)
        NotificationCenter.default.post(name: keyName2, object: nil)
    }
    
}

//MARK: - LocationManagerDelegate
extension TabBarController: LocationManagerDelegate {
    
    // Updated Location
    func didUpdateLocation(_ locationData: [Double]) {
        sunPositionManager.currentData.Longitude = locationData[0]
        sunPositionManager.currentData.Latitude = locationData[1]
        
        /* START SUN POSITION SYSTEM */
        if let _ = sunPositionManager.currentData.SunAltitudeChange {}
        else { sunPositionManager.startSunPositionSystem() }
    }
    
    func didUpdateCityName(_ cityname: String) {
        currentLocation = cityname.uppercased()
        
        // Braodcast
        let keyName = Notification.Name(rawValue: CityNameUpdateNotificationKey)
        NotificationCenter.default.post(name: keyName, object: nil)
    }
}

//MARK: - TimerManagerDelegate
extension TabBarController: TimerManagerDelegate {
    
    func didUpdateTimer(_ hour: Int, _ min: Int, _ sec: Int) {
        timerHour = String(format: "%02d", hour)
        timerMin = String(format: "%02d", min)
        timerSec = String(format: "%02d", sec)
        
        // update SunAltitude every 10 seconds
        if (sec%10 == 0)
        {
            updateSunAngle()
        }
        
        // Braodcast
        let keyName = Notification.Name(rawValue: TimerUpdateNotificationKey)
        NotificationCenter.default.post(name: keyName, object: nil)
    }
    
    func didEndTimer() {
        sunPositionManager.updateScreen()
    }
}
