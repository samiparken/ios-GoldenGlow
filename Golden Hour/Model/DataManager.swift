import Foundation
import RealmSwift

class DataManager {
    
    /* Realm Database*/
    // Initialize Realm
    let realm = try! Realm()
    
    // Realm Object
    var locationData: Results<LocationData>?
    var selectedLocationData: LocationData?
    var timestampData: Results<TimestampData>?

    func storeLocationData(_ newLocationData: LocationData) {
    
        let cityName = newLocationData.cityName
        let countryCode = newLocationData.countryCode
        
        // Realm, DB Check & Store
        locationData = realm.objects(LocationData.self).filter("cityName == %@ AND countryCode == %@", cityName, countryCode)
        if ( locationData!.count == 0 )
        {
            do {
                try realm.write { // Make Realm updated
                    realm.add(newLocationData)
                }
            } catch {
                print("Error saving newLocationData \(error)")
            }
            locationData = realm.objects(LocationData.self).filter("cityName == %@ AND countryCode == %@", cityName, countryCode)
        }
    }
    
    
    func readTimestampData(_ locationData: LocationData, _ date: Date) -> Results<TimestampData>? {
        
        // Realm, check today timestamp
        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay: Date = {
          let components = DateComponents(day: 1, second: -1)
          return Calendar.current.date(byAdding: components, to: startOfDay)!
        }()
        
        timestampData = locationData.timestampDataSet.filter("time BETWEEN %@", [startOfDay, endOfDay])
        
        return timestampData
    }
        
    
    
}
