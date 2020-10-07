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
    
    // Set BG & morning/evening
    func didUpdateCurrentState(_ sunAngle: Double, _ isUp: Bool) {
        
        //BG update
        switch sunAngle {
        case -90 ..< -6 : BGImageViewName = "BG_Night";   isEvening = false; isToday = isUp ? true : false
            sunPulsePosition = 0.8 ;  wavePosition = 0.5
        case -6  ..< -4 : BGImageViewName = "BG_Blue";    isEvening = isUp ? false : true
            sunPulsePosition = 0.7 ; wavePosition = 0.5
        case -4  ..< 0  : BGImageViewName = "BG_Golden-"; isEvening = isUp ? false : true
            sunPulsePosition = 0.6 ; wavePosition = 0.5
        case 0   ..< 6  : BGImageViewName = "BG_Golden+"; isEvening = isUp ? false : true
            sunPulsePosition = 0.5 ; wavePosition = 0.6
        case 6   ..< 10 : BGImageViewName = "BG_LowSun";  isEvening = isUp ? false : true
            sunPulsePosition = 0.3; wavePosition = 0.7
        default         : BGImageViewName = "BG_Day";     isEvening = true
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





//MARK: - Custom Rounded Border
extension UIView {
    func topRoundedCorners(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topLeft , .topRight],
                                     cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}


//MARK: - Custom Side Border
extension CALayer {
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height, width: UIScreen.main.bounds.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width, y: 0, width: thickness, height: self.frame.height)
            break
        default:
            break
        }
        border.backgroundColor = color.cgColor;
        self.addSublayer(border)
    }
}


//MARK:- UILabel Character Spacing
extension UILabel {
    func addCharacterSpacing(_ spacing: Double = 1.30) {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}

extension UIButton{
    func addCharacterSpacing(_ spacing: CGFloat = 1.30) {
        if let labelText = self.titleLabel?.text!, labelText.count > 0 {
            print("labelText : \(labelText)")
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSRange(location: 0, length: attributedString.length - 1 ))
            self.setAttributedTitle(attributedString, for: .normal)
        }
    }
}

//MARK: - For HEX Color Code
// *Usage*
// view.backgroundColor = UIColor.init(rgb: 0xF58634)     // + .cgColor
extension UIColor {
    convenience init(rgb: UInt) {
        self.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgb & 0x0000FF) / 255.0, alpha: CGFloat(1.0))
    }
}

