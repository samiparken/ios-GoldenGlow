import RealmSwift

class LocationData: Object {
    //dynamic : being monitored while running
    @objc dynamic var cityName: String = ""
    @objc dynamic var countryName: String = ""
    @objc dynamic var countryCode: String = ""
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var latitude: Double = 0.0
        
    //Relationship
    let timestampDataSet = List<TimestampData>()  //Initialize with empty List of Timestamp
}
