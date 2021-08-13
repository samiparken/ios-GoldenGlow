import UIKit
import CoreLocation
import UserNotifications

class TabBarController: UITabBarController {
    let defaults = UserDefaults.standard
    
    // Managers
    var sunPositionManager = SunPositionManager()
    var locationManager = LocationManager()
    var timerManager = TimerManager()

    let calendar = Calendar.current
    
    /* for Sharing Data Btw View Controllers */
    static let singletonTabBar = TabBarController()
    
    // BG & Location
    var BGImageViewName: String?
    var BGImageColor: String?
    var currentCityName: String?
    var isDifferentTimezone: Bool = false
    var localTime: String?
    
    // SkyView1 Timer
    var currentState: String = ""
    var nextState: String = ""
    var timerHour: String = ""
    var timerMin: String = ""
    var timerSec: String = ""
    var sunAngle: Double = 0.0 {
        didSet {
            if sunAngle != oldValue {
                // Braodcast
                let keyName = Notification.Name(rawValue: SunAngleUpdateNotificationKey)
                NotificationCenter.default.post(name: keyName, object: nil)
            }
        }
    }
    var sunPulsePosition: CGFloat = 0.0 {
        didSet {
            if sunPulsePosition != oldValue {
                // Braodcast
                let keyName = Notification.Name(rawValue: SunPulsePositionUpdateNotificationKey)
                NotificationCenter.default.post(name: keyName, object: nil)
            }
        }
    }
    var wavePosition: CGFloat = 0.0 {
        didSet {
            if wavePosition != oldValue {
                // Braodcast
                let keyName = Notification.Name(rawValue: WavePositionUpdateNotificationKey)
                NotificationCenter.default.post(name: keyName, object: nil)
            }
        }
    }
    
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
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Delegates
        sunPositionManager.delegate = self
        locationManager.delegate = self
        timerManager.delegate = self
        
        askNotificationPermission()
        
        // check UserDefaults for presentLocation
        if let cityName = defaults.string(forKey: K.UserDefaults.PresentLocation.cityName),
           let countryName = defaults.string(forKey: K.UserDefaults.PresentLocation.countryName),
           let countryCode = defaults.string(forKey: K.UserDefaults.PresentLocation.countryCode)
           {
            let long = defaults.double(forKey: K.UserDefaults.PresentLocation.long)
            let lat = defaults.double(forKey: K.UserDefaults.PresentLocation.lat)

            //Star SunPositionManager()
            sunPositionManager.initSunPositionSystem(cityName, countryName, countryCode, long: long, lat: lat)
        }
        
        // if not, try to get a current location
    }
    
//MARK: - Init
    func askNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound], completionHandler: {(granted, error) in })
    }
    
//MARK: - Methods
    func updateSunAngle() {
        sunAngle = sunPositionManager.SunAltitude ?? 0
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
    
    func didUpdateCurrentCity(_ cityName: String) {
        
        currentCityName = cityName.uppercased()
                        
        isDifferentTimezone = sunPositionManager.timezoneOffset == 0 ? false : true
        if isDifferentTimezone {
            timerManager.startLocalTime()
        } else {
            timerManager.endLocalTime()
        }

        // Braodcast: CityName & LocalTime to Show
        let keyName = Notification.Name(rawValue: CityNameUpdateNotificationKey)
        NotificationCenter.default.post(name: keyName, object: nil)
    }
    
    
    // Set BG & morning/evening
    func didUpdateCurrentState(_ sunAngle: Double, _ isUp: Bool) {
        
        //BG update
        switch sunAngle {
        case -90 ..< -6 : BGImageColor = K.COLOR.nighttime;
            isEvening = false; isToday = isUp ? true : false
            sunPulsePosition = 0.8 ;  wavePosition = 0.5
        case -6  ..< -4 : BGImageColor = K.COLOR.blueHour;
            isEvening = isUp ? false : true;
            sunPulsePosition = 0.7 ; wavePosition = 0.5
        case -4  ..< -0.5  : BGImageColor = K.COLOR.goldenHourM;
            isEvening = isUp ? false : true
            sunPulsePosition = 0.6 ; wavePosition = 0.5
        case -0.5 ..< 0.5 : BGImageColor = K.COLOR.setrise;
            isEvening = isUp ? false : true;
            sunPulsePosition = 0.6 ; wavePosition = 0.5
        case 0.5   ..< 6  : BGImageColor = K.COLOR.goldenHourP;
            isEvening = isUp ? false : true;
            sunPulsePosition = 0.5 ; wavePosition = 0.6
        case 6   ..< 10 : BGImageColor = K.COLOR.lowSun;
            isEvening = isUp ? false : true
            sunPulsePosition = 0.3; wavePosition = 0.7
        default         : BGImageColor = K.COLOR.daytime;
            isEvening = true
            sunPulsePosition = 0.15; wavePosition = 0.8
        }
        
        // Broadcast
        let keyName = Notification.Name(rawValue: BGImageUpdateNotificationKey)
        NotificationCenter.default.post(name: keyName, object: nil)
        
        //SunAngle update
        updateSunAngle()
    }
    
    func didUpdateCurrentScan(from: Date, to: Date, _ nowState: Int, _ _nextState: Int) {
        
        switch nowState  {
        case DAYTIME: currentState = "DAYTIME"
        case LOWSUN: currentState = "LOW SUN"
        case GOLDENHOURP: currentState = "GOLDEN HOUR +"
        case SETRISE: currentState = _nextState == GOLDENHOURP ? "SUNRISE" : "SUNSET"
        case GOLDENHOURM: currentState = "GOLDEN HOUR -"
        case BLUEHOUR: currentState = "BLUE HOUR"
        case NIGHTTIME: currentState = "NIGHTTIME"
        default: currentState = "ERROR"
        }
              
        switch _nextState  {
        case DAYTIME: nextState = "DAYTIME"
        case LOWSUN: nextState = "LOW SUN"
        case GOLDENHOURP: nextState = "GOLDEN HOUR +"
        case SETRISE: nextState = nowState == GOLDENHOURM ? "SUNRISE" : "SUNSET"
        case GOLDENHOURM: nextState = "GOLDEN HOUR -"
        case BLUEHOUR: nextState = "BLUE HOUR"
        case NIGHTTIME: nextState = "NIGHTTIME"
        default: nextState = "ERROR"
        }

        // Broadcast CurrentState
        let keyName = Notification.Name(rawValue: CurrentStateUpdateNotificationKey)
        NotificationCenter.default.post(name: keyName, object: nil)

        // Start Timer
        timerManager.startTimer(to)
        
//        //TotalDuration
//        let duration = to.timeIntervalSince1970 - from.timeIntervalSince1970
//
//        //remaining
//        let remaining = to.timeIntervalSince1970 - Date().timeIntervalSince1970
//
//        //percent
//        let percent = remaining / duration * 100
        
    }
    
    func didUpdateTodayScan(_ today: [SunTimestamp]) {
        
        self.morningCellData = []   // 5 x 2 + 1 = 13
        self.eveningCellData = []   // 5 x 2 + 1 = 13
        
        var timestamps: [SunTimestamp] = today
        var end: Date, start: Date
        var currentState = timestamps[0].to
        
        // Morning scan
        while( (timestamps.count > 0) )
        {
            start = timestamps[0].time
            if (timestamps[0].to == SETRISE) {
                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: start)
                let minute = calendar.component(.minute, from: start)
                sunriseTime = String(format: "%02d:%02d", hour, minute)
            }
            let newTimeCellData = CellData( time: start )
            morningCellData.append(newTimeCellData)
            
            timestamps.removeFirst(1)
            if( (timestamps.count == 0) || (currentState == DAYTIME)) { break }
            else {
                end = timestamps[0].time
                let _duration = Int((end.timeIntervalSince1970 - start.timeIntervalSince1970) / 60)
                let durationString = String(format: "%dmin", _duration)
                let newTitleCellData = CellData(state: currentState, duration: durationString, isEvening: false)
                morningCellData.append(newTitleCellData)
                
                currentState = timestamps[0].to
            }
        }
        
        // Morning Total Duration
        morningTotalTime = calculateTotalDuration(morningCellData)

        
        // Evening Scan
        if( timestamps.count > 0 ) { currentState = timestamps[0].to }
        while( (timestamps.count > 0) )
        {
            start = timestamps[0].time
            if (timestamps[0].to == SETRISE) {
                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: start)
                let minute = calendar.component(.minute, from: start)
                sunsetTime = String(format: "%02d:%02d", hour, minute)
            }
            let newTimeCellData = CellData( time: start )
            eveningCellData.append(newTimeCellData)
            
            timestamps.removeFirst(1)
            if( (timestamps.count == 0) || (currentState == NIGHTTIME)) { break }
            else {
                end = timestamps[0].time
                let _duration = Int((end.timeIntervalSince1970 - start.timeIntervalSince1970) / 60)
                let durationString = String(format: "%dmin", _duration)
                let newTitleCellData = CellData(state: currentState, duration: durationString, isEvening: true)
                eveningCellData.append(newTitleCellData)
                
                currentState = timestamps[0].to
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
    
    // Updated Current CityName & CountryCode
    func didUpdateLocation(_ place: CLPlacemark) {

        // Current Location
        let cityName = place.locality ?? ""
        let countryName = place.country ?? ""
        let countryCode = place.isoCountryCode ?? ""
        let long = place.location?.coordinate.longitude
        let lat = place.location?.coordinate.latitude
        print("Longitude: \(long ?? 0), Latitude: \(lat ?? 0)")
                
        if let _ = defaults.string(forKey: K.UserDefaults.PresentLocation.cityName) {
            
        } else {
            self.defaults.set(cityName, forKey: K.UserDefaults.PresentLocation.cityName)
            self.defaults.set(countryName, forKey: K.UserDefaults.PresentLocation.countryName)
            self.defaults.set(countryCode, forKey: K.UserDefaults.PresentLocation.countryCode)
            self.defaults.set(long, forKey: K.UserDefaults.PresentLocation.long)
            self.defaults.set(lat, forKey: K.UserDefaults.PresentLocation.lat)

            //Start SunPositionManager()
            sunPositionManager.initSunPositionSystem(cityName, countryName, countryCode, long: long!, lat: lat!)
        }
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
        sunPositionManager.refreshCurrentState()
    }
    
    func didUpdateLocaltime() {
        let now = Date() + sunPositionManager.timezoneOffset
        let hh = String(format: "%02d", calendar.component(.hour, from: now))
        let mm = String(format: "%02d", calendar.component(.minute, from: now))
        
        self.localTime = hh + ":" + mm
        
        // Braodcast
        let keyName = Notification.Name(rawValue: LocalTimeUpdateNotificationKey)
        NotificationCenter.default.post(name: keyName, object: nil)
    }
}
