
// Type Property
// static : make it constant. You can use it somewhere as Constants.registerSegue
// struct K is convention.

struct K {
    static let REMINDER_TIMING_MODEL = [
    "On Time",
    "5 Mins Before",
    "15 Mins Before",
    "30 Mins Before",
    "1 Hour Before"
    ]
    
}



//MARK: - Keys for Notification Observers

// TabBarController
let CityNameUpdateNotificationKey = "co.samiparken.goldenglow.updateCityName"
let BGImageUpdateNotificationKey = "co.samiparken.goldenglow.updateBGImage"
let TimerUpdateNotificationKey = "co.samiparken.goldenglow.updateTimer"
let SunAngleUpdateNotificationKey = "co.samiparken.goldenglow.updateSunAngle"

let MorningEveningReadyNotificationKey = "co.samiparken.goldenglow.morningEveningReady"
let CurrentStateUpdateNotificationKey = "co.samiparken.goldenglow.currentState"

let SunPulsePositionUpdateNotificationKey = "co.samiparken.goldenglow.SunPulsePositionUpdate"
let wavePositionUpdateNotificationKey = "co.samiparken.goldenglow.wavePositionUpdate"


