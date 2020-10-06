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

    var BGImageViewName: String?
    var currentLocation: String?

    // SkyView1 Timer
    var timerHour: String = ""
    var timerMin: String = ""
    var timerSec: String = ""
    var sunAngle: Int = 0
    var sunPulsePosition: CGFloat = 0.0
    var wavePosition: CGFloat = 0.0
    
    // SkyView2 Times
    var morningTime: [String] = []   // morningTime.count == 4
    var morningDuration: [Int] = []  // morningDuration.count == 3
    var eveningTime: [String] = []   // eveningTime.count == 4
    var eveningDuration: [Int] = []  // eveningDuration.count == 3
    var sunriseTime: String = ""
    var sunsetTime: String = ""
    
    // SkyView2 Bottom Button
    var isEvening: Bool = true
    var isToday: Bool = true
    
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
        let tempAngle = Int(sunPositionManager.getAltitude())
        
        if tempAngle != sunAngle
        {
            sunAngle = tempAngle
            // Braodcast
            let keyName = Notification.Name(rawValue: SunAngleUpdateNotificationKey)
            NotificationCenter.default.post(name: keyName, object: nil)
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
        timerManager.remainingTime = Int(remaining)
        timerManager.startTimer()
    }
    
    func didUpdateTodayScan(_ today: [Date]) {
        
        var dates: [Date] = today   // dates.count == 10
        let calendar = Calendar.current
        var hour: Int
        var minute: Int
        var end:Double, start: Double
        
        for i in 1...4 {
            hour = calendar.component(.hour, from: dates[0])
            minute = calendar.component(.minute, from: dates[0])
            morningTime.append(String(format: "%02d:%02d", hour, minute))
            
            start = dates[0].timeIntervalSince1970
            dates.removeFirst(1)
            if( i == 2)
            {
                hour = calendar.component(.hour, from: dates[0])
                minute = calendar.component(.minute, from: dates[0])
                sunriseTime = String(format: "%02d:%02d", hour, minute)
                dates.removeFirst(1)
            }
            if ( i != 4)
            {
                end = dates[0].timeIntervalSince1970
                morningDuration.append( Int(end - start) / 60 )
            }
        }
        
        for i in 1...4 {
            hour = calendar.component(.hour, from: dates[0])
            minute = calendar.component(.minute, from: dates[0])
            eveningTime.append(String(format: "%02d:%02d", hour, minute))
            
            start = dates[0].timeIntervalSince1970
            dates.removeFirst(1)
            if ( i == 2 )
            {
                hour = calendar.component(.hour, from: dates[0])
                minute = calendar.component(.minute, from: dates[0])
                sunsetTime = String(format: "%02d:%02d", hour, minute)
                dates.removeFirst(1)
            }
            if (i != 4)
            {
                end = dates[0].timeIntervalSince1970
                eveningDuration.append( Int(end - start) / 60 )
            }
        }
        
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

