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
    func didUpdateCoordinate(_ locationData: [Double])
    func didUpdateLocation(_ location: CLPlacemark)
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
    
    func getCoordinate(city: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(city) { completion($0?.first?.location?.coordinate, $1) }
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
                
                self.delegate?.didUpdateLocation(placemark)
                
                // Get Coordinate from CityName
                self.getCoordinate(city: placemark.locality!) { coordinate, error in
                    guard let coordinate = coordinate, error == nil else { return }
                    
//                    // don't forget to update the UI from the main thread
//                    DispatchQueue.main.async {
                        
                    print("\(placemark.locality ?? "?") Location:, \(coordinate)")
                    
                    var locationData:[Double] = []
                    locationData.append(coordinate.longitude)
                    locationData.append(coordinate.latitude)
                    self.delegate?.didUpdateCoordinate(locationData)
//
//                    }
                }
            }
            
            // Get longitude & latitude
//            var locationData:[Double] = []
//            locationData.append(location.coordinate.longitude)
//            locationData.append(location.coordinate.latitude)
//            self.delegate?.didUpdateCoordinate(locationData)
        }
    }
}
