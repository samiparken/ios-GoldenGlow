//
//  ViewController.swift
//  Golden Hour
//
//  Created by Sam on 8/27/20.
//  Copyright © 2020 Sam. All rights reserved.
//
// Development Process
// + Timer / Activate
// + Timer / Apply current time
// + API : Calculate Sun's altitude based on Location
// + API : Show City Name based on Location

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    @IBOutlet weak var currentLocationOutlet: UIButton!

    @IBOutlet weak var BGImageView: UIImageView!
    
    @IBOutlet weak var centerTopLabel: UILabel!
    @IBOutlet weak var timeDigitMin: UILabel!
    @IBOutlet weak var timeSaperator: UILabel!
    @IBOutlet weak var timeDigitSec: UILabel!
    @IBOutlet weak var centerButtomLabel: UILabel!
    
    @IBOutlet weak var buttomLabel: UILabel!
    
    
    // For Timer
    var countdownTimer: Timer!
    var remainingTime: Int = 0
    
    // For Location
    var locationManager = CLLocationManager()
    
    // For Sun Position
    var sunPositionManager = SunPositionManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegates
        locationManager.delegate = self
        sunPositionManager.delegate = self

        locationManager.requestWhenInUseAuthorization()  //Ask user location data Permission
        locationManager.requestLocation()                //Get location
        
        
    }
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        let minutes: Int = (remainingTime / 60) % 60
        let seconds: Int = remainingTime % 60
        
        timeDigitMin.text = String(format: "%02d", minutes)
        timeDigitSec.text = String(format: "%02d", seconds)

        // update every 5 seconds
        if (remainingTime % 5 == 0)
        {
            sunPositionManager.updateCurrentAltitude()
            let sunAltitude = sunPositionManager.getCurrentAltitude()
            buttomLabel.text = String(format: "%2.2f", sunAltitude)
        }
        
        if remainingTime > 0 { remainingTime -= 1 }
        else { endTimer() }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
    }
    
    func calculateSunPosition()
    {
        // current Sun Altitude
        let currentAltitude = sunPositionManager.getCurrentAltitude()
        buttomLabel.text = String(format: "%2.2f", currentAltitude)
        
        if (sunPositionManager.isGoldenHour())
        {
            print("Golden Hour")
            BGImageView.image = UIImage(named: "BG_Golden")
        }
        else
        {
            print("Not Golden Hour")
            BGImageView.image = UIImage(named: "BG_Day")
        }
        
//        let endDate = sunPositionManager.getNextEnd(0)
//
//        let calendar = Calendar.current
//        let year = calendar.component(.year, from: endDate)
//        let month = calendar.component(.month, from: endDate)
//        let day = calendar.component(.day, from: endDate)
//        let hour = calendar.component(.hour, from: endDate)
//        let minute = calendar.component(.minute, from: endDate)
//        let second = Double(calendar.component(.second, from: endDate))
//        let result = "\(year)-\(month)-\(day), \(hour):\(minute):\(second)"
//
//        print("Golden Hour Ends at \(result)")
        
    }
    

    
    
    @IBAction func currentLocationButtonPressed(_ sender: UIButton) {
        //self.performSegue(withIdentifier: "goToSearch", sender: self)
        //locationManager.requestLocation()
    }
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        //self.performSegue(withIdentifier: "goToSearch", sender: self)
    }
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        
    }
        
    // Prepare for Switching Screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSearch" {
            let destinationVC = segue.destination as! SearchViewController
            //            destinationVC.totalPerPerson = calculatorBrain.getTotalPerPerson()
            //            destinationVC.splitNumber = calculatorBrain.getSplitNumber()
            //            destinationVC.tipPct = calculatorBrain.getTipPct()
        }
    }
}

//MARK: - SunPositionManagerDelegate
extension MainViewController: SunPositionManagerDelegate {
    
    
    
    
}


//MARK: - CLLocationManagerDelegate
extension MainViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {  // last is more accurate

            // + Update when the city name has changed
            
            // Get longitude & latitude
            sunPositionManager.currentData.Longitude = location.coordinate.longitude
            sunPositionManager.currentData.Latitude = location.coordinate.latitude

            // Start Calculating
            sunPositionManager.updateCurrentAltitude()

            // Try Timer
            remainingTime = 3 * 60 + 30
            startTimer()
        }
    }
}
