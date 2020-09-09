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
        sunPositionManager.delegate = self
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
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

        // update SunAltitude every 5 seconds
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
        sunPositionManager.updateScreen()
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
    
    // -1:Night / 0:Golden / 1:Day
    func didUpdateStatus(_ status: Int) {
        switch status {
        case -1: BGImageView.image = UIImage(named: "BG_Night")
        case 0:  BGImageView.image = UIImage(named: "BG_Golden")
        case 1:  BGImageView.image = UIImage(named: "BG_Day")
        default: BGImageView.image = UIImage(named: "BG_Start")
        }
    }
    
    func didUpdateEndGoldenHour(_ endtime: Date) {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: endtime)
        let minute = calendar.component(.minute, from: endtime)
        centerTopLabel.text = "Ends in"
        centerButtomLabel.text = "Ends at " + String(format: "%02d:%02d", hour, minute)
    }
    
    func didUpdateNextGoldenHour(_ next: [Date]) {
        let start = next[0]
        let end = next[1]

        centerTopLabel.text = "Lasts for"
        let last = Int( end.timeIntervalSince1970 - start.timeIntervalSince1970 )
        let lastMin: Int = (last / 60) % 60
        let lastSec: Int = last % 60
        timeDigitMin.text = String(format: "%02d", lastMin)
        timeDigitSec.text = String(format: "%02d", lastSec)

        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: start)
        let minute = calendar.component(.minute, from: start)
        
        centerButtomLabel.text = "Starts at " + String(format: "%02d:%02d", hour, minute)
    }
    
    
    func didUpdateRemainingTime(_ time: Int) {
        // Try Timer
        remainingTime = time
        startTimer()
    }
    
}


//MARK: - CLLocationManagerDelegate
extension MainViewController: CLLocationManagerDelegate {

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
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {  // last is more accurate

            // + Update when the city name has changed
            
            // Get longitude & latitude
            sunPositionManager.currentData.Longitude = location.coordinate.longitude
            sunPositionManager.currentData.Latitude = location.coordinate.latitude

            // Start Calculating
            sunPositionManager.startSunPositionSystem()

        }
    }
}
