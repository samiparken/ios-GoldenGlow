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

    func storeLocationData(_ cityName: String,
                           _ countryName: String,
                           _ countryCode: String,
                           long: Double,
                           lat: Double) {
            
        // Realm, DB Check & Store
        locationData = realm.objects(LocationData.self).filter("cityName == %@ AND countryCode == %@", cityName, countryCode)
        
        if ( locationData!.count == 0 )
        {
            let newLocationData = LocationData() //Realm Object
            newLocationData.cityName = cityName
            newLocationData.countryName = countryName
            newLocationData.countryCode = countryCode
            newLocationData.longitude = long
            newLocationData.latitude = lat
            
            do {
                try realm.write { // Make Realm updated
                    realm.add(newLocationData)
                }
            } catch {
                print("Error saving newLocationData \(error)")
            }
        }
    }
    
    
    func readTimestampData(_ cityName: String,
                           _ countryCode: String,
                           _ date: Date) -> Results<TimestampData>? {
        
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
