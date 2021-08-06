import UIKit
import RealmSwift
import CoreLocation


class TabBarController: UITabBarController {
    
    /* Realm Database*/
    // Initialize Realm
    let realm = try! Realm()
    
    // Realm Object
    var locationData: Results<LocationData>?
    var selectedLocationData: LocationData?
    var timestampData: Results<TimestampData>?

    /* for Sharing Data Btw View Controllers */
    static let singletonTabBar = TabBarController()
    
    // BG & Location
    var BGImageViewName: String?
    var currentLocation: String?
    
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
                let keyName = Notification.Name(rawValue: wavePositionUpdateNotificationKey)
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
        sunAngle = sunPositionManager.getAltitude()
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
        case -90 ..< -6 : BGImageViewName = "BG_Night";
            isEvening = false; isToday = isUp ? true : false
            sunPulsePosition = 0.8 ;  wavePosition = 0.5
        case -6  ..< -4 : BGImageViewName = "BG_Blue";
            isEvening = isUp ? false : true;
            sunPulsePosition = 0.7 ; wavePosition = 0.5
        case -4  ..< -0.5  : BGImageViewName = "BG_Golden-";
            isEvening = isUp ? false : true
            sunPulsePosition = 0.6 ; wavePosition = 0.5
        case -0.5 ..< 0.5 : BGImageViewName = "BG_Golden-";
            isEvening = isUp ? false : true;
            sunPulsePosition = 0.6 ; wavePosition = 0.5
        case 0.5   ..< 6  : BGImageViewName = "BG_Golden+";
            isEvening = isUp ? false : true;
            sunPulsePosition = 0.5 ; wavePosition = 0.6
        case 6   ..< 10 : BGImageViewName = "BG_LowSun";
            isEvening = isUp ? false : true
            sunPulsePosition = 0.3; wavePosition = 0.7
        default         : BGImageViewName = "BG_Day";
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
    
    // Updated Current CityName & CountryCode
    func didUpdateLocation(_ place: CLPlacemark) {

        // Current Location
        let cityName = place.locality
        let countryName = place.country
        let countryCode = place.isoCountryCode
        let long = place.location?.coordinate.longitude
        let lat = place.location?.coordinate.latitude
        print("Longitude: \(long ?? 0), Latitude: \(lat ?? 0)")
        
        // for calculation
        sunPositionManager.currentData.Longitude = long
        sunPositionManager.currentData.Latitude = lat

        
        // Realm, DB Check & Store
        locationData = realm.objects(LocationData.self).filter("cityName == %@ AND countryCode == %@", cityName!, countryCode!)
        if ( locationData!.count == 0 )
        {
            let newLocationData = LocationData() //Realm Object
            newLocationData.cityName = cityName!
            newLocationData.countryName = countryName!
            newLocationData.countryCode = countryCode!
            newLocationData.longitude = long!
            newLocationData.latitude = lat!
            do {
                try realm.write { // Make Realm updated
                    realm.add(newLocationData)
                }
            } catch {
                print("Error saving newLocationData \(error)")
            }
            locationData = realm.objects(LocationData.self).filter("cityName == %@ AND countryCode == %@", cityName!, countryCode!)
        }
                
        // Braodcast: CityName to Show
        currentLocation = cityName!.uppercased()
        let keyName = Notification.Name(rawValue: CityNameUpdateNotificationKey)
        NotificationCenter.default.post(name: keyName, object: nil)
        
        
        // Realm, check today timestamp
        let todayStart = Calendar.current.startOfDay(for: Date())
        let todayEnd: Date = {
          let components = DateComponents(day: 1, second: -1)
          return Calendar.current.date(byAdding: components, to: todayStart)!
        }()
        selectedLocationData = locationData![0]
        timestampData = selectedLocationData?.timestampDataSet.filter("time BETWEEN %@", [todayStart, todayEnd])
        if( timestampData!.count == 0)
        {
            // scan data & store timestamps in RealmDB

            
            
            
            
            /* START SUN POSITION SYSTEM */
            if let _ = sunPositionManager.currentData.SunAltitudeChange {}
            else { sunPositionManager.startSunPositionSystem() }
            
        } else {
            timestampData = timestampData?.sorted(byKeyPath: "time", ascending: true)
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
        sunPositionManager.updateScreen()
    }
}
