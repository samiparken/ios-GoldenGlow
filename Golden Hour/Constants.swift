
// Type Property
// static : make it constant. You can use it somewhere as Constants.registerSegue
// struct K is convention.

struct K {
    
    struct UserDefaults {

        struct PresentLocation {
            static let cityName = "presentLocationCity"
            static let countryName = "presentLocationCountry"
            static let countryCode = "presentLocationCountryCode"
            static let lat = "presentLocationLatitude"
            static let long = "presentLocationLongitude"
        }
        
        struct Notification {
            static let sunrise = "notifySunrise"
            static let sunset = "notifySunset"
            static let lowSunMorning = "notifyLowSunMorning"
            static let lowSunEvening = "notifyLowSunEvening"
            static let goldenHourMorning = "notifyGoldenHourMorning"
            static let goldenHourEvening = "notifyGoldenHourEvening"
            static let blueHourMorning = "notifyBlueHourMorning"
            static let blueHourEvening = "notifyBlueHourEvening"
            static let reminderTiming = "notifyreminderTiming"
        }
        
        struct Setting {
            static let timeFormat = "settingTimeFormat"
        }
    }
    
    struct COLOR {
        static let daytime = "4E89CB"
        static let lowSun = "CCA65B"
        static let goldenHourP = "D88350"
        static let setrise = "D85050"
        static let goldenHourM = "8B5AA7"
        static let blueHour = "1C1E5A"
        static let nighttime = "0A092B"        
    }
        
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
let LocalTimeUpdateNotificationKey = "co.samiparken.goldenglow.updateLocaltime"

let SunAngleUpdateNotificationKey = "co.samiparken.goldenglow.updateSunAngle"

let MorningEveningReadyNotificationKey = "co.samiparken.goldenglow.morningEveningReady"
let CurrentStateUpdateNotificationKey = "co.samiparken.goldenglow.currentState"

let SunPulsePositionUpdateNotificationKey = "co.samiparken.goldenglow.SunPulsePositionUpdate"
let WavePositionUpdateNotificationKey = "co.samiparken.goldenglow.WavePositionUpdate"
let WaveRefreshNotificationKey = "co.samiparken.goldenglow.WaveRedraw"
