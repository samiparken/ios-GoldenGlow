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
        }
    }
    
    
    func readTimestampData(_ lData: LocationData,
                           _ date: Date) -> Results<TimestampData>? {
        
        let cityName = lData.cityName
        let countryCode = lData.countryCode

        locationData = realm.objects(LocationData.self).filter("cityName == %@ AND countryCode == %@", cityName, countryCode)
        
        selectedLocationData = locationData![0]
        
        // Realm, check today timestamp
        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay: Date = {
          let components = DateComponents(day: 1, second: -1)
          return Calendar.current.date(byAdding: components, to: startOfDay)!
        }()
        
        timestampData = selectedLocationData?.timestampDataSet.filter("time BETWEEN %@", [startOfDay, endOfDay])
        timestampData = timestampData?.sorted(byKeyPath: "time", ascending: true)

        return timestampData
    }
}
