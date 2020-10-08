//
//  LocationManager.swift
//  Golden Hour
//
//  Created by Sam on 9/9/20.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation
import CoreLocation
protocol LocationManagerDelegate {
    func didUpdateLocation(_ locationData: [Double])
    func didUpdateCityName(_ cityname: String)
}

class LocationManager: NSObject {
    var delegate: LocationManagerDelegate?
    
    let locationManager = CLLocationManager()
    
    // - API
    public var exposedLocation: CLLocation? {
        return self.locationManager.location
    }
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestLocation()
    }
    
}

//MARK: - Get Placemark
extension LocationManager {
    
    func getPlace(for location: CLLocation, completion: @escaping (CLPlacemark?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            
            completion(placemark)
        }
    }
}


//MARK: - CLLocationManager Delegate
extension LocationManager: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined         : print("notDetermined")        // location permission not asked for yet
        case .authorizedWhenInUse   : print("authorizedWhenInUse")  // location authorized
        case .authorizedAlways      : print("authorizedAlways")     // location authorized
        case .restricted            : print("restricted")           // TODO: handle
        case .denied                : print("denied")               // TODO: handle
        default                     : print("location error")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {  // last is more accurate
            
            // + Update when the city name has changed
            getPlace(for: location) { placemark in
                guard let placemark = placemark else { return }
                
                var  output = ""
                if let town = placemark.locality {
                    output = town
                }
                self.delegate?.didUpdateCityName(output)
            }
            
            // Get longitude & latitude
            var locationData:[Double] = []
            locationData.append(location.coordinate.longitude)
            locationData.append(location.coordinate.latitude)
            self.delegate?.didUpdateLocation(locationData)
        }
    }
}
