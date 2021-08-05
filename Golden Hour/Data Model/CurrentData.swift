import Foundation

struct CurrentData {

    var GMT: Double = Double(TimeZone.current.secondsFromGMT()) / 3600
    var Longitude: Double?
    var Latitude: Double?
    var SunAltitude: Double?
    var SunAltitudeChange: Double?   //Rate of Change
    
    var isMorning: Bool?       // for PlanView
    
}
